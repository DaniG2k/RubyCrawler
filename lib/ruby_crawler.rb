require 'ruby_crawler/configuration'
require 'ruby_crawler/version'
require 'pry'

module RubyCrawler
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
