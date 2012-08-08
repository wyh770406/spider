# encoding: utf-8

class Merchant
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true
#  field :merchantlogo

  field :desc
  field :service


  field :merchanturl

  has_many :products

#  mount_uploader :merchantlogo, MerchantlogoUploader

  has_and_belongs_to_many :top_products  #, :stored_as => :array, :inverse_of => :top_products, :class_name => 'TopProduct',:foreign_key => 'top_product_ids'



  # validates_url_format_of :merchanturl, :allow_blank => true,:message=>"错误的url格式"
end