# encoding: utf-8

require 'nokogiri'
require 'open-uri'

require File.expand_path("../../models/rss_item", __FILE__)

class CrawlUtil
  RSS_URL = YAML.load_file(File.expand_path("../../config/app_configs.yml", __FILE__))['rss_url']

  class << self
    def analyze(status = 'init')
      rss = Nokogiri::XML(open(RSS_URL))
      today = Time.now.to_date
      count = 0
      RssItem.delete_all if 'init' == status
      File.open(File.expand_path("../../log/info.log", __FILE__), "w") do |file|
        file.puts "#{Time.now}====>start #{status} data."
        rss.css('item').each do |item|
          rss_item = extract(item)
          if 'init' == status
            rss_item.body = body(rss_item.link)
            rss_item.save
          else
            if valid(rss_item, today)
              break
            end
            rss_item.body = body(rss_item.link)
            rss_item.save
          end
          file.puts "#{Time.now}====>#{rss_item.link}"
          file.flush
          count += 1
          sleep(rand 5)
        end
        file.puts "#{status} data has #{count} count"
        file.puts "#{Time.now}====>end #{status} data."
      end
    rescue
      File.open(File.expand_path("../../log/info.log", __FILE__), "w+") do |file|
        file.puts "error #{$!.class}: #{$!.message}"
      end
    end

    def extract(item)
      # You will get text from rss xml file.
      # Example like this:
      rss_item = RssItem.new
      ## rss_item.title = h(item.css('title'))
      ## rss_item.description = h(item.css('description'))
      ## rss_item.link = h(item.css('link'))
      ## rss_item.guid = h(item.css('guid'))
      ## rss_item.pubDate = Time.parse(h(item.css('pubDate')))
      rss_item
    end

    def valid(rss_item, today)
      # You will valid rss item data in here.
      # Example like this:
      ## RssItem.has?(rss_item.link) || (today - rss_item.pubDate.to_date).to_i <= 7
    end

    def body(url)
      # You will get rss content data in here.
      # Example like this:
      ## Nokogiri::HTML(open(url)).css('div#content').inner_html
    end

    def h(dom)
      Nokogiri::HTML(dom.inner_text.strip).inner_text.strip
    end
  end

end
