class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|

      t.integer :invoice_id
      t.text :concept
      t.integer :quantity
      t.float :amount

      t.timestamps
    end
  end
end
