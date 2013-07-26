module ArchiveLister
  class WaybackFile
    attr_reader :urls

    def initialize(urls)
      @urls = urls
    end

    def self.parse(content)
      doc = Nokogiri::HTML(content)
      WaybackFile.new(
        doc.css('td.url a').map do |url_node|
          Addressable::URI.parse(url_node.text).tap do |url|
            url.port = nil if (url.port == 80 && url.scheme == 'http')
            url.port = nil if (url.port == 443 && url.scheme == 'https')
          end
        end
      )
    end
  end
end