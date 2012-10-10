# FullContentRss

从非全文的rss输出中抓取对应的全文信息，并生成rss文件。

## 主要技术

* Sinatra
* Mongoid
* Nokogiri

推荐使用`ruby 1.9.3`

## 准备工作

    git clone git://github.com/ywjno/full-content-rss.git
    cd full-content-rss
    bundle install
    cp config/app_configs.yml.example config/app_configs.yml
    cp config/mongoid.yml.example config/mongoid.yml
## 定制

在 config/app_configs.yml, 需要替换成你所需字段, 比如:

    site_name: 全文输出 Feed
    rss_url: http://www.example.com/news/rss.xml
    xml_title: 新闻
    xml_description: example网新闻全文输出
    xml_link: http://www.example.com/news
    time_zone: +08:00
    scheduler_time: 2h
其中`scheduler_time`的值的写法请参照[rufus-scheduler](https://github.com/jmettraux/rufus-scheduler)中所提供例子

修改`rss_item.rb`、`crawl_util.rb`中已注释掉的代码，请根据实际情况情形修改或添加所需功能

## 启动

    # 生成初始数据，会把该rss输出的所有内容都抓取下来
    rake init
    # 如果数据太多只想抓取最新的内容则运行
    # rake update

    # 启动服务
    ruby app.rb -p 4567
    # 或者如下
    # rackup -p 4567
