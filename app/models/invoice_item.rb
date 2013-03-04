class InvoiceItem < ActiveRecord::Base

  belongs_to :invoice

  validates_presence_of :invoice_id, :quantity, :amount
  validates_numericality_of :quantity, :amount


  def self.create(attributes = {})

    invoice_item = InvoiceItem.new
    invoice_item.update_attributes(attributes)

    if invoice_item.valid?
      invoice_item.save
      return invoice_item
    end
  end

  def base_amount
    quantity * amount
  end

end
