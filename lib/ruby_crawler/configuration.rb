module RubyCrawler
  class Configuration
    attr_accessor :polite, :start_urls, :include_patterns, :exclude_patterns

    def initialize
      @polite = nil
      @start_urls = nil
      @include_patterns = nil
      @exclude_patterns = nil
    end
  end
end
