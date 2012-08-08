# encoding: utf-8
require 'open-uri'
require 'timeout'
module Spider
  class NormalDownloader < Downloader
    def initialize(items)
      @items = items
    end

    def run
      @items.each do |item|
  
        begin
          html = open(item.url).read
        rescue  Exception=>e
		  puts item.url
          puts "HTTP Connection Error?" ##Timeout::Error, Errno::ECONNREFUSED
          #logger.error("#{item.class} #{item.kind} #{item.url} HTTP Connection Error.")
        else
          begin
            item = Encoding.set_utf8_html(item, html)
	    if !Utils.valid_html?(item.html)
              logger.error("#{item.class} #{item.kind} #{item.url} Bad HTML.")
            else
              yield(item)
            end
          rescue Exception=>e
            puts item.url
			puts e.message
            puts "invalid byte sequence in UTF-8 (ArgumentError)"
          else
          end

        end
      end
    end
  end
end