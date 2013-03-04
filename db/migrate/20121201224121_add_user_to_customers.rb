class AddUserToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :user_id, :integer, :null => false
  end
end
