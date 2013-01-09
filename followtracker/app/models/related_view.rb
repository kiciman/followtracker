class RelatedView < ActiveRecord::Base
  belongs_to :profile
  
  attr_accessible :company, :link, :name, :title
end
