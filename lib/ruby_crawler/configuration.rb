module RubyCrawler
  class Configuration
    attr_accessor :start_urls,
      :include_patterns,
      :exclude_patterns
    attr_writer :polite

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
