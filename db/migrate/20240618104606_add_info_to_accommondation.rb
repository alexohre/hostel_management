class AddInfoToAccommondation < ActiveRecord::Migration[7.0]
  def change
    add_column :accommondations, :account_id, :integer
    add_column :accommondations, :room_type_id, :integer
  end
end
