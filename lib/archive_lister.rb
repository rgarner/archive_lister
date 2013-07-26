require 'archive_lister/version'

require 'addressable/uri'
require 'net/http'
require 'nokogiri'

require 'archive_lister/wayback_file'

module ArchiveLister
  WAYBACK_FORMAT = 'http://wayback.archive.org/web/*/#SITE#/*'

  def self.list(url)
    query_uri = url.is_a?(URI) ? url : URI.parse(url)
    query_uri.query = nil

    wayback_uri = URI(WAYBACK_FORMAT.sub('#SITE#', query_uri.to_s))

    response = Net::HTTP.get_response(wayback_uri)
    raise RuntimeError "#{response}" unless response.is_a?(Net::HTTPSuccess)

    WaybackFile.parse(response.body).urls
  end
end
