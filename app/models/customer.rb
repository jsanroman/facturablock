class Customer < ActiveRecord::Base

  belongs_to :user
  has_many :invoices

  validates_presence_of :name


  def self.secure_create _user, attributes

    Customer.transaction do
      customer = Customer.new
      customer.user = _user
      customer.update_attributes(attributes)
      customer.save

      return customer
    end
  end

  def self.secure_update attributes

    Customer.transaction do
      customer = Customer.find(attributes[:id])
      customer.update_attributes(attributes)

      return customer
    end
  end

  def self.secure_remove customer_id

    Customer.transaction do
      customer = Customer.find(customer_id)

      # delete all invoices for this customer
      customer.invoices.each do |invoice|
        Invoice.secure_remove(invoice.id)
      end

      Customer.delete(customer_id)
    end
  end

end
