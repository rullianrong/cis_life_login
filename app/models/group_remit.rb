class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary
  
  has_many :batches, dependent: :destroy
  accepts_nested_attributes_for :batches, allow_destroy: true
end

