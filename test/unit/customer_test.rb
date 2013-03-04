require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test "secure_create" do

    @attr = { 
      :name    => 'Cliente 4',
      :address => 'Dirección cliente 4',
      :nif     => 'Nif Cliente 4'
      }

    customer = Customer.secure_create( User.find(1), @attr)

    assert_not_nil customer
    assert customer.valid?
    assert_equal @attr[:name], customer.name
    assert_equal @attr[:address], customer.address
  end


  test "secure_update" do 

    @attr = { 
      :id      => 2,
      :name    => 'Cliente 2',
      :address => 'Dirección cliente 2',
      :nif     => 'Nif Cliente 2'
      }

    customer = Customer.secure_update(@attr)

    assert_not_nil customer
    assert customer.valid?
    assert_equal @attr[:name], customer.name
    assert_equal @attr[:address], customer.address
  end


  test "secure_remove" do

    assert Customer.exists?(2)

    Customer.secure_remove 2

    # remove customer
    assert !Customer.exists?(2)

    # remove invoices customer
    assert Invoice.count(:id, :conditions => ['customer_id=?', 2])==0
  end
end
