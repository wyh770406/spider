class TopProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true
  field :order_num, :type=>Integer,:default=>0
#  field :topicon
  #paginates_per 20
  #field :merchant_ids,  :type=> Array, :default=> []

#  mount_uploader :topicon, TopiconUploader

  has_many :middle_products,:dependent=>:destroy
  has_and_belongs_to_many :merchants #, :stored_as => :array, :inverse_of => :merchants, :class_name => 'Merchant',:foreign_key => 'merchant_ids'
  has_and_belongs_to_many :brands#, :stored_as => :array, :inverse_of => :brands,:foreign_key => 'brand_ids'

end
