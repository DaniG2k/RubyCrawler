require 'open-uri'
require 'nokogiri'
require 'pry'

require 'ruby_crawler/version'
require 'ruby_crawler/configuration'
require 'ruby_crawler/spider'

module RubyCrawler
  class << self
    attr_accessor :configuration, :spider

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    def crawl
      @spider = Spider.new.start_crawl
    end

    # def stored
    #   @spider.stored
    # end
  end
end
