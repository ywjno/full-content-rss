# encoding: utf-8

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
  # field :pubDate, type: Time

  # validates :title, :description, :body, :link, :pubDate, presence: true

  def self.has?(link)
    self.where(link: link).exists?
  end
end
