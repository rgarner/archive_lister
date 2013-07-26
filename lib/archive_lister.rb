require 'archive_lister/version'

require 'addressable/uri'
require 'net/http'
require 'nokogiri'

require 'archive_lister/wayback_file'

module ArchiveLister
  class HttpError < RuntimeError
    attr_reader :uri, :response

    def initialize(uri, response)
      @uri = uri
      @response = response
    end

    def to_s
      "#{uri}\t#{response}"
    end
  end

  WAYBACK_FORMAT = 'http://wayback.archive.org/web/*/#SITE#/*'

  def self.list(url)
    query_uri = url.is_a?(URI) ? url : URI.parse(url)
    query_uri.query = nil

    wayback_uri = URI(WAYBACK_FORMAT.sub('#SITE#', query_uri.to_s))

    # Poor man's one-level redirect
    response = Net::HTTP.get_response(wayback_uri)
    if response.is_a?(Net::HTTPRedirection)
      response = Net::HTTP.get_response(URI(response.header['location']))
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise HttpError.new(wayback_uri, response)
    end

    WaybackFile.parse(response.body).urls
  end

  def self.batch(url_filename, output_dir, options = {})
    successes, skipped, failures = 0, 0, []

    File.read(url_filename).each_line do |url|
      normalised_url = url.sub(/(\n$)|(_$)|(\/\n$)/, '')
      url = Addressable::URI.parse(normalised_url)
      output_filename = File.join(output_dir, "#{url.host}#{url.path.gsub('/', '_')}").chomp

      File.delete(output_filename) if File.exist?(output_filename) && File.zero?(output_filename)
      skipping = options[:skip_existing] && File.exist?(output_filename)
      puts "#{url}#{skipping ? ' -- Skipping' : ''}"
      skipped += 1 and next if skipping

      File.open(output_filename, 'w') do |file|
        begin
          urls = ArchiveLister.list(url)
          urls.each { |url| file.puts url.to_s }
          successes += 1
        rescue HttpError => e
          failures << e
          File.delete(output_filename)
        end
      end
    end

    puts "#{successes} successes, #{failures.length} failures, #{skipped} skipped"
    failures.each { |e| puts e } if options[:verbose]
  end
end
