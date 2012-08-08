#encoding: utf-8
require 'mongoid'
require 'zlib'
require 'mongoid/tree'
require "redis"
gem "bson_ext"

module Spider
  module Utils
    extend self
    
    def valid_html?(html)
      html =~ /<\/html>(<!--(.*?)-->|\s)*$/mi
    end
    
    def query2hash(query_str)
      Hash[query_str.split("&").map{|pairs| pairs.split("=")}]
    end
    
    def hash2query(hash)
      hash.map{|pairs| pairs.join("=")}.join("&")
    end

    def decompress_gzip(string)
      io = StringIO.new(string)
      gzip = Zlib::GzipReader.new(io)
      gzip.read
    end

    def load_models
      Dir.glob("#{File.dirname(__FILE__)}/../models/**/*.rb").
        sort_by{|file| file.size}.
        each do |file|
        puts "Loading File: #{File.expand_path(file)}"
        require file
        end
    end

    def load_mongo(environment)
      path     = File.expand_path(File.dirname(__FILE__) + "/../config/mongoid.yml")
      settings = YAML.load(ERB.new(File.new(path).read).result)[environment]
      Mongoid.from_hash(settings)
    end

    def load_redis(environment)
      path     = File.expand_path(File.dirname(__FILE__) + "/../config/redis.yml")
      redis_config = YAML.load(ERB.new(File.new(path).read).result)[environment]

      $redis = Redis.new(:host => redis_config[:host],:port => redis_config[:port])
    end

    def load_fetcher
      require File.expand_path(File.dirname(__FILE__) + "/../fetcher")
    end

    def load_parser
      require File.expand_path(File.dirname(__FILE__) + "/../parser")
    end

    def load_digger
      require File.expand_path(File.dirname(__FILE__) + "/../digger")
    end

    def load_paginater
      require File.expand_path(File.dirname(__FILE__) + "/../paginater")
    end

    def load_downloader
      require File.expand_path(File.dirname(__FILE__) + "/../downloader")
    end

    #module_function :load_mongo, :load_models, :load_digger, :load_parser, :load_fetcher, :load_paginater, :decompress_gzip, :load_downloader, :valid_html?
  end
end
