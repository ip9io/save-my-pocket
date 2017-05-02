class Bookmark < ActiveRecord::Base
  has_many :taggables
  has_many :tags, through: :taggables
end
