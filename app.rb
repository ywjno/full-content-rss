# encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'bundler/setup'
require 'rufus/scheduler'
require "#{settings.root}/lib/database"
require "#{settings.root}/models/rss_item"

configure do
  configs = YAML.load_file("#{settings.root}/config/app_configs.yml")

  set :site_name, configs['site_name']
  set :title, configs['xml_title']
  set :description, configs['xml_description']
  set :web_link, configs['web_link']
  set :time_zone, configs['time_zone']

  scheduler = Rufus::Scheduler.start_new
  scheduler.every configs['scheduler_time'], :first_at => Time.now do
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
        xml.title settings.title
        xml.description settings.description
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
