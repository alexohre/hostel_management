class AddMatNoToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :mat_no, :string
  end
end
