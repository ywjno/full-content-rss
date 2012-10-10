# encoding: utf-8

require 'mongoid'

ENV['RACK_ENV'] ||= 'development'
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__), ENV['RACK_ENV'])
