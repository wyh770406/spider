# encoding: utf-8
class CatePath
  include Mongoid::Document

  field :url, :type => String
  field :name, :type => String
  
  embedded_in :product_url

end
