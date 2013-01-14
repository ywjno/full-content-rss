# encoding: utf-8

require 'nokogiri'
require 'open-uri'

class RssItem
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  # You will change to like rss xml field.
  # Example like this:
  # field :title, type: String
  # field :description, type: String
  # field :body, type: String
  # field :link, type: String
  # field :guid, type: String
  # field :pub_date, as: :pubDate, type: Time

  # validates :title, :description, :body, :link, :pub_date, presence: true

  before_validation :extract_body

  def self.extract_xml_item
    rss_url = YAML.load_file(File.expand_path("../../config/app_configs.yml", __FILE__))['rss_url']
    Nokogiri::XML(open(rss_url)).css('item')
  end

  def extract(xml_item)
    # You will get text from rss xml file.
    # Example like this:
    ## self.title = h(xml_item.css('title'))
    ## self.description = h(xml_item.css('description'))
    ## self.link = h(xml_item.css('link'))
    ## self.guid = h(xml_item.css('guid'))
    ## self.pub_date = Time.parse(h(xml_item.css('pubDate')))
  end

  def valid(today)
    # You will valid rss item data in here.
    # Example like this:
    ## RssItem.where(link: link).exists? || (today - rss_item.pubDate.to_date).to_i <= 7
  end

  def extract_body
    # You will get rss content data in here.
    # Example like this:
    ## self.body = Nokogiri::HTML(open(link)).css('div#content').inner_html.strip
  end

  def h(dom)
    Nokogiri::HTML(dom.inner_text.strip).inner_text.strip
  end
end
