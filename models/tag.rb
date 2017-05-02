class Tag < ActiveRecord::Base
  has_many :taggables
  has_many :bookmark, through: :taggables
end