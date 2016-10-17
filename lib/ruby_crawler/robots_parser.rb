module RubyCrawler
  class RobotsParser

    def initialize
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
            parse_line = !(line =~ /User\-agent:\s+\*/).nil? ? true : false
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

  end
end
