class AddHostelTypeToRoomTypes < ActiveRecord::Migration[7.0]
  def change
    add_reference :room_types, :hostel_type, null: false, foreign_key: true
  end
end
