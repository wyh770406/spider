#!/usr/bin/env ruby -EUTF-8
# encoding: utf-8
require 'open-uri'
require 'nokogiri'
require 'timeout'
require 'rtesseract'
require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")
require File.expand_path(File.dirname(__FILE__) + "/../utils/optparse")
require File.expand_path(File.dirname(__FILE__) + "/../logger")

Spider::Utils.load_mongo(SpiderOptions[:environment])
Spider::Utils.load_models

include Spider::Logger

#开始解析
def start_updat(product)
doc = Nokogiri::HTML(open(product.product_url.url).read.encode("UTF-8",  :undef => :replace, :replace => "?", :invalid => :replace))
product.update_attributes(:image_url => doc.css("#prodImageCell img")[0][:src] ) if doc.css("#prodImageCell img")[0]
puts doc.css("#prodImageCell img")[0][:src]
puts "succesfully update image url"
end

products = Product.from_kind(SpiderOptions[:name]).where(:image_url => nil).and(:image_url_exist => true).limit(SpiderOptions[:number])
products.each do |product|
  start_updat(product)
end
