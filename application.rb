#encoding: utf-8

require "rubygems"
require "bundler"
require "i18n"

module Xlsx2txt
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end

    # Initialize the application
    def self.initialize!
      Encoding.default_external = 'utf-8'
    end

  end
end

Bundler.require(:default, Xlsx2txt::Application.env)

Dir['./lib/**/*.rb'].each {|f| require f}

# Preload application classes
Dir['./app/**/*.rb'].each {|f| require f}

# Roo::Excelx::EXCEPTIONAL_FORMATS[ "[$-FC19]dd\\ mmmm\\ yyyy\\ \\г\\.;@" ] = :date

Russian::init_i18n
