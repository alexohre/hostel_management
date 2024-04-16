class RoomType < ApplicationRecord
  belongs_to :hostel_type
  has_many :rooms

  validates :name, :price, presence: true
  validate :unique_name_within_hostel_type

  def name_with_hostel
    "#{hostel_type.name} - #{name}" # Assuming hostel has a name attribute
  end

  private

  def unique_name_within_hostel_type
    if hostel_type && hostel_type.room_types.where.not(id: id).exists?(name: name)
      errors.add(:name, "must be unique within the #{hostel_type.name}")
    end
  end
end