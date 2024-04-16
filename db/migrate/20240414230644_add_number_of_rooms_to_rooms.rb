class AddNumberOfRoomsToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :number_of_beds, :integer
  end
end
