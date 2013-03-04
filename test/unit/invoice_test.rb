require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase

  test "secure_create" do

    @attr = { 
      :number  => 2,
      :date    => '2013-05-05',
      :concept => 'New invoice',
      :vat     => 21,
      :irpf	   => 9,
      :customer_id => 1
      }

    invoice = Invoice.secure_create( User.find(1), @attr, nil)

    assert_not_nil invoice
    assert invoice.valid?
    assert_equal @attr[:number], invoice.number
    assert_equal @attr[:customer_id], invoice.customer_id


    invoice = Invoice.secure_create( User.find(1), @attr, nil)
    # number repeat
    assert !invoice.valid?
    assert_equal @attr[:number], invoice.number
  end

end
