module RubyCrawler
  class Configuration
    attr_accessor :polite, :start_urls, :include_patterns, :exclude_patterns

    def initialize
      @polite = true
      @start_urls = []
      @include_patterns = []
      @exclude_patterns = []
    end

    def polite?
      @polite
    end
  end
end
