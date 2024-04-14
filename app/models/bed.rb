class Bed < ApplicationRecord
  belongs_to :room
  has_one :account
end