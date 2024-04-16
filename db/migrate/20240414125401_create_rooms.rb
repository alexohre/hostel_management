class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :room_number
      t.references :room_type, null: false, foreign_key: true
      t.integer :status, default: 0
      
      t.timestamps
    end
  end
end
