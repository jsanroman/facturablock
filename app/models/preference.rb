class Preference < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :vat_default, :irpf_default, :business_name, :business_address, :business_nif
  validates_numericality_of :vat_default, :irpf_default



end
