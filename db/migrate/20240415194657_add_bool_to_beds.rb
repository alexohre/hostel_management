class AddBoolToBeds < ActiveRecord::Migration[7.0]
  def change
    add_column :beds, :reserved, :boolean, default: false
  end
end
