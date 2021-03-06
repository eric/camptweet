require 'rubygems'
require 'active_support'
require 'time'
require 'twitter'
require 'tinder'
require 'simple-rss'
require 'open-uri'

Dir[File.join(File.dirname(__FILE__), 'camptweet/**/*.rb')].sort.each { |lib| require lib }

module Camptweet
  class Error < StandardError; end
end
