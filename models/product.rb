# coding: utf-8
module BaseModel
  extend ActiveSupport::Concern

  module ClassMethods
    # Redis 搜索存储索引
    def redis_search_index(options = {})
      title_field = options[:title_field] || :title
      ext_fields = options[:ext_fields] || []
      class_eval %(
        def redis_search_ext_fields(ext_fields)
          exts = {}
          ext_fields.each do |f|
            exts[f] = instance_eval(f.to_s)
          end
          exts
        end

        after_create :create_search_index
        def create_search_index
          s = Search.new(:title => self.#{title_field}, :id => self.id,
      :exts => self.redis_search_ext_fields(#{ext_fields}),
        :type => self.class.to_s)

      puts "how long did it save saved saved???????????"
      s.save
      puts "really very long time???????????"
    end

    before_destroy :remove_search_index
    def remove_search_index
      Search.remove(:title => self.#{title_field}, :type => self.class.to_s)
        end

        before_update :update_search_index
        def update_search_index
          index_fields_changed = false
          #{ext_fields}.each do |f|
          next if f.to_s == "id"
          if instance_eval(f.to_s + "_changed?")
            index_fields_changed = true
          end
        end
        begin
          if(self.#{title_field}_changed?)
              index_fields_changed = true
            end
          rescue
          end
          if index_fields_changed
            Rails.logger.debug { "-- update_search_index --" }
            Search.remove(:title => self.#{title_field}_was, :type => self.class.to_s)
              self.create_search_index
            end
          end
        )
      end
    end
  end

  class Product
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Timestamps::Updated
    include BaseModel
  
    scope :from_kind, ->(kind){where(:kind => kind)}

    field :price, :type => Float, :precision => 10, :scale => 2, :default=>0
    field :price_url, :type => String
    field :title, :type => String
    field :stock, :type => Integer
    field :kind, :type  => String
    field :image_url, :type => String
    field :desc, :type => String
    field :image_info, :type => Array
    field :score, :type => Integer
    field :standard, :type => String
    field :product_code, :type => String
    field :product_url_id, :type => BSON::ObjectId
    field :union_url, :type => String  , :unique => true
    field :order_num, :type=>Integer,:default=>10000000
    field :click_count, :type => Integer, :default => 0
    field :image_url_exist , :type => Boolean, :default => true
    belongs_to :product_url

    belongs_to :merchant
    belongs_to :brand
    belongs_to :end_product
    belongs_to :brand_type

    embeds_many :comments

  index(
    [
      [ :kind, Mongo::ASCENDING ],
      [ :title, Mongo::ASCENDING ]
    ],
    unique: true
  )

   # validates_presence_of :union_url
   # validates_uniqueness_of :title
    validates_numericality_of :order_num,only_integer:true
    redis_search_index(:title_field => :title)
  end


