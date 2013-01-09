class Company < ActiveRecord::Base
  has_many :profiles
  attr_accessible :link, :name
end
