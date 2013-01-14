# encoding: utf-8

require File.expand_path("../../models/rss_item", __FILE__)

class CrawlUtil
  class << self
    def analyze(status = 'init')
      today = Time.now.to_date
      count = 0
      RssItem.delete_all if 'init' == status
      File.open(File.expand_path("../../log/info.log", __FILE__), "w") do |log_file|
        log_file.puts "#{Time.now}====>start #{status} data."
        RssItem.extract_xml_item.each do |xml_item|
          rss_item = RssItem.new
          rss_item.extract_item(xml_item)
          if 'init' == status
            rss_item.save!
          else
            break if rss_item.valid(today)
            rss_item.save!
          end
          log_file.puts "#{Time.now}====>#{rss_item.link}"
          log_file.flush
          count += 1
          sleep(rand 5)
        end
        log_file.puts "#{status} data has #{count} count"
        log_file.puts "#{Time.now}====>end #{status} data."
      end
    rescue
      File.open(File.expand_path("../../log/info.log", __FILE__), "w+") do |log_file|
        log_file.puts "error #{$!.class}: #{$!.message}"
      end
    end
  end
end
