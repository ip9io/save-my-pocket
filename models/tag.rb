class Tag < ActiveRecord::Base
  has_many :taggables
  has_many :bookmarks, through: :taggables
end