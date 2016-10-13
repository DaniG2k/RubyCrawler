module RubyCrawler
  class Spider
    attr_accessor :stored, :frontier

    def initialize
      @stored = []
      @frontier = []
    end

    def start_crawl
      RubyCrawler.configuration.start_urls.each do |url|
        html_doc = ::Nokogiri::HTML(open(url))

        links = html_doc.xpath('//a[@href]').map do |link|
          URI.join(url, link['href']).to_s
        end

        # Remove links that math exclude pattern.
        links.reject! do |link|
          RubyCrawler.configuration.exclude_patterns.any? do |pat|
            link =~ pat
          end
        end

        # Append links that match include pattern to frontier.
        links.each do |link|
          RubyCrawler.configuration.include_patterns.any? do |pat|
            @frontier << link if link =~ pat
          end
        end

      end
    end
  end
end
