class CreateAccommondations < ActiveRecord::Migration[7.0]
  def change
    create_table :accommondations do |t|
      t.string :ref_no
      t.decimal :amount
      t.string :hostel
      t.string :room_type
      t.integer :room_no
      t.string :bed
      t.boolean :active
      t.string :session

      t.timestamps
    end
  end
end
