# encoding: utf-8

require 'rubygems'
require 'sinatra/base'
require 'sinatra/config_file'
require 'bundler/setup'
require 'builder'
require 'rufus/scheduler'
require "#{File.dirname(__FILE__)}/lib/database"
require "#{File.dirname(__FILE__)}/models/rss_item"

class App < Sinatra::Base
  register Sinatra::ConfigFile

  config_file "#{settings.root}/config/app_configs.yml"

  configure :production do
    scheduler = Rufus::Scheduler.start_new
    scheduler.every settings.scheduler_time, :first_at => Time.now do
      system "ruby script/spider.rb"
    end
  end

  get '/' do
    "<a href='/rss.xml'>#{settings.site_name}</a>"
  end

  get '/rss.xml' do
    content_type 'application/rss+xml'
    builder do |xml|
      xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
      xml.rss :version => "2.0" do
        xml.channel do
          xml.title settings.xml_title
          xml.description settings.xml_description
          xml.link settings.web_link

          RssItem.order_by(pubDate: :desc).limit(50).each do |item|
            xml.item do
              xml.title item.title
              xml.link item.link
              xml.guid item.guid
              xml.description item.body
              xml.pubDate item.pubDate.getlocal(settings.time_zone).rfc822()
            end
          end
        end
      end
    end
  end

  run! if app_file == $0
end
