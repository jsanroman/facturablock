class AddUserToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :user_id, :integer, :null => false
  end
end
