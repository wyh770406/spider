class EndProduct
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :name, unique: true
  field :order_num, :type=>Integer,:default=>0

  belongs_to :middle_product
  has_many :products,:dependent=>:destroy
  validates_numericality_of :order_num,only_integer:true

end