module RubyCrawler
  class Spider

    def initialize
      @stored = []
      @frontier = []
      @assets = {}
    end

    def stored
      @stored
    end

    def assets
      @assets
    end

    def parse_robots_txt
      robots = RubyCrawler.configuration.start_urls.map do |url|
        uri = URI.parse(url)
        "#{uri.scheme}://#{uri.host}/robots.txt"
      end

      robots.each do |url|
        doc = ::Nokogiri::HTML(open(url))
        rules = doc.at('body').text.split("\n").reject {|line| !(line =~ /^#|^$/).nil?}

        parse_line = false
        rules.each do |line|
          # Switch to parse / not parse:
          if !(line =~ /User\-agent/).nil?
            if !(line =~ /User\-agent:\s+\*/).nil?
              parse_line = true
            else
              parse_line = false
            end
          # Append to include patterns:
          elsif parse_line && !(line =~ /Allow/).nil?
            allowed = Regexp.new(line.gsub(/Allow:\s+/,''))
            unless RubyCrawler.configuration.include_patterns.include?(allowed)
              RubyCrawler.configuration.include_patterns << allowed
            end
          # Append to exclude patterns:
          elsif parse_line && !(line =~ /Disallow/).nil?
            disallowed = Regexp.new(line.gsub(/Disallow:\s+/,''))
            unless RubyCrawler.configuration.exclude_patterns.include?(disallowed)
              RubyCrawler.configuration.exclude_patterns << disallowed
            end
          end
        end

      end
    end

    def start_crawl
      if RubyCrawler.configuration.polite?
        parse_robots_txt
      end

      RubyCrawler.configuration.start_urls.each do |url|
        @frontier << url
      end

      until @frontier.empty?
        url = @frontier.shift
        @stored << url
        parse_page(url)
      end
    end

    def parse_page(url)
      begin
        html_doc = ::Nokogiri::HTML(open(url))

        # Gather static assets in the @assets hash.
        @assets[url] = {
          :css => html_doc.css('link[rel=stylesheet]').map {|css| URI.join(url, css['href']).to_s },
          :images => html_doc.xpath("//img/@src").map {|img| URI.join(url, img).to_s },
          :javascript => html_doc.css('script').map {|js| src = js['src']; src.to_s unless src.nil?}.compact
        }

        links = html_doc.xpath('//a[@href]').map do |link|
          url = URI.join(url, link['href']).to_s
          if is_relative?(url) || (matches_include_patterns?(url) && !matches_exclude_patterns?(url))
            url
          end
        end

        links.each do |link|
          if !link.nil? && !@frontier.include?(link) && !@stored.include?(link)
            @frontier << link
          end
        end
        #puts "Stored:\n#{@stored}\n"
      rescue URI::InvalidURIError => e
        puts "Invalid url: #{url}\n#{e}"
      rescue Exception => e
        puts e.message
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
