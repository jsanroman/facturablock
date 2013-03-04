class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.string :name
      t.text :address
      t.string :nif

      t.timestamps
    end
  end
end
