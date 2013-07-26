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
          Addressable::URI.parse(url_node.text)
        end
      )
    end
  end
end