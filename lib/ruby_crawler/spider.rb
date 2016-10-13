module RubyCrawler
  class Spider
    attr_accessor :stored, :frontier

    def initialize
      @stored = []
      @frontier = []
      @invalid = []
    end

    def start_crawl
      RubyCrawler.configuration.start_urls.each do |url|
        parse_page(url)
      end

      until @frontier.empty?
        url = @frontier.shift
        parse_page url
      end
    end

    def parse_page(url)
      begin
        html_doc = ::Nokogiri::HTML(open(url))

        links = html_doc.xpath('//a[@href]').map do |link|
          URI.join(url, link['href']).to_s
        end

        # Remove links that math exclude pattern.
        links.reject! do |link|
          RubyCrawler.configuration.exclude_patterns.any? do |pat|
            link =~ pat
          end || @stored.include?(link)
        end

        # Append links that match include pattern to frontier.
        links.each do |link|
          RubyCrawler.configuration.include_patterns.any? do |pat|
            if link =~ pat && !@frontier.include?(link)
              @frontier << link
            end
          end
        end
        puts @frontier.size
        # Append to stored list.
        @stored << url
      rescue URI::InvalidURIError
        puts "Invalid url: #{url}"
      end
    end
  end
end
