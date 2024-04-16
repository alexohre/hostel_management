class Room < ApplicationRecord
  belongs_to :room_type
  has_many :beds

  enum status: [:available, :unavailable]

  validates :room_type_id, presence: { message: "must be selected" }
  
  validates :room_number, uniqueness: { scope: :room_type_id, message: "must be unique within the hostel type" }

  validates :number_of_beds, presence: true


end