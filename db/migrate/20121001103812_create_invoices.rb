class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|

      t.date :date
      t.text :concept
      t.float :import
      t.float :vat
      t.float :irpf
      t.integer :customer_id

      t.timestamps
    end
  end
end
