class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|

      t.integer :user_id
      t.integer :vat_default
      t.integer :irpf_default
      t.string :business_name
      t.text :business_address
      t.string :business_nif
      t.string :business_phone
      t.string :business_fax
      t.string :business_email


      t.timestamps
    end
  end
end
