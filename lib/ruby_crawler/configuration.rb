module RubyCrawler
  class Configuration
    attr_accessor :polite,
      :start_urls,
      :include_patterns,
      :exclude_patterns,
      :max_depth

    def initialize
      @polite = true
      @start_urls = []
      @include_patterns = []
      @exclude_patterns = []
      #@max_depth = nil
    end

    def polite?
      @polite
    end
  end
end
