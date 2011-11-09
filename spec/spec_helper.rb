require 'rubygems'
require 'bundler/setup'
require 'rack/test'


$:.unshift File.expand_path("../../lib", __FILE__)
require 'rack_gist' 

module Rack::Test::Methods
  def self.included(klass)
    class << klass
      attr_accessor :app
    end
  end

  def body
    last_response.body
  end

  def status
    last_response.status
  end

  def headers
    last_response.headers
  end

  def app
    self.class.app
  end
end
