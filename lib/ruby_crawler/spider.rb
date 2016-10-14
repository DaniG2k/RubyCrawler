module RubyCrawler
  class Spider
    attr_accessor :stored, :frontier

    def initialize
      @stored = []
      @frontier = []
    end

    def start_crawl
      RubyCrawler.configuration.start_urls.each do |url|
        @frontier << url
      end

      until @frontier.empty?
        url = @frontier.shift
        parse_page(url)
        @stored << url
      end
    end

    def parse_page(url)
      begin
        html_doc = ::Nokogiri::HTML(open(url))

        links = html_doc.xpath('//a[@href]').map do |link|
          url = URI.join(url, link['href']).to_s
          if is_relative?(url) || matches_include_patterns?(url) || !matches_exclude_patterns?(url)
            url
          end
        end

        links.each do |link|
          if !@frontier.include?(link) && !@stored.include?(link)
            @frontier << link
          end
        end
        @frontier.uniq!
        puts "Stored:\n#{@stored}"
        #puts "Frontier:\n#{@frontier}"
        #sleep 5
      rescue URI::InvalidURIError => e
        puts "Invalid url: #{url}\n#{e}"
      #rescue OpenURI::HTTPError
      end
    end

    def is_relative?(url)
      !(url =~ /^\//).nil?
    end

    def matches_include_patterns?(url)
      RubyCrawler.configuration.include_patterns.any? do |pat|
        !(url =~ pat).nil?
      end
    end

    def matches_exclude_patterns?(url)
      RubyCrawler.configuration.exclude_patterns.any? do |pat|
        !(url =~ pat).nil?
      end
    end

  end
end
