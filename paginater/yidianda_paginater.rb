# encoding: utf-8
require 'nokogiri'
module Spider
  class YidiandaPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      
      p_cate = {"1" => ["86", "210"], "3" => ["87", "88", "202"], "4" => ["89", "90"], "5" => ["235"]}
      
      s_cate = {"86"=>["93", "95", "219"], "210"=>["96", "97", "98", "99", "185", "209", "220"],
        "87"=>["100", "101"], "88"=>["113", "114", "119", "231", "279", "353"],
        "202"=>["108", "110", "175", "270", "273"], "89"=>["122", "123", "125", "305"], "90"=>["116"],
        "235"=>["236", "249", "250", "251"]}
      
      max_page = doc.css("span#ctl00_contentBody_lblUpCurrentPage").text.scan(/\d+/).last.to_i
      
      num = url.scan(/\d+/).last
      
      s_num = ""
      s_cate.each do |k, v|
        if v.include? num
          s_num = k
          break
        end
      end
      
      if s_num.present?
        p_num = ""
        p_cate.each do |k, v|
          if v.include? s_num
            p_num = k
            break
          end
        end
      else
        raise "s_num is not found"
      end
      
      if s_num.present? && p_num.present?
        (1..max_page).map do |i|
          url.sub("?Category=#{num}", "?Category=#{p_num}-#{s_num}-#{num}-0-0-0-0-0-0-0-0-1-#{i}")
        end
      end
    end
  end
end
