require 'ruby_crawler/configuration'
require 'ruby_crawler/version'
require 'pry'

module RubyCrawler
  class << self
    attr_accessor :configuration
  end
  
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
