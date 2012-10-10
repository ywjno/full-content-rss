# encoding: utf-8

require File.expand_path("../crawl_util", __FILE__)

class Crawl
  class << self
    def run
      update
    end

    def init
      CrawlUtil.analyze
    end

    def update
      CrawlUtil.analyze('update')
    end
  end
end
