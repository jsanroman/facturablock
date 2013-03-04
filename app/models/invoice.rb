class Invoice < ActiveRecord::Base

  belongs_to :user
  belongs_to :customer
  has_many :invoice_items

  validates :date, :date_format => true
  validates_presence_of :date, :concept, :vat, :irpf, :customer_id
  validates_numericality_of :vat, :irpf, :customer_id
  validates :number, :invoice_number => true


  def self.secure_create _user, attributes, invoice_items_attributes
    Invoice.transaction do

      # create general data
      invoice = Invoice.new
      invoice.user = _user
      invoice.update_attributes(attributes)
      if invoice.save
        # if save general data => create invoice items
        invoice.remove_and_create_invoice_items invoice_items_attributes
      end

      return invoice
    end

    return nil
  end

  def self.secure_update attributes, invoice_items_attributes
    Invoice.transaction do

      # update general data
      invoice = Invoice.find(attributes[:id])
      invoice.update_attributes(attributes)
      if invoice.save
        # if save general data => remove/create invoice items
        invoice.remove_and_create_invoice_items invoice_items_attributes
      end

      return invoice
    end

    return nil
  end

  def self.secure_remove invoice_id

    Invoice.transaction do

      invoice = Invoice.find(invoice_id)

      # delete all invoice_items for this invoice
      invoice.invoice_items.each do |invoice_item| 
        InvoiceItem.delete invoice_item.id
      end

      Invoice.delete invoice.id
    end
  end

  def remove_and_create_invoice_items (invoice_items_params)
    # first remove invoice_items
    InvoiceItem.delete_all(["invoice_id=?", self.id])

    # then add all new invoice_items valid
    if !invoice_items_params.nil?
      invoice_items_params.sort.each do |key, invoice_item_params|

        invoice_item_params[:invoice_id] = self.id
        invoice_item = InvoiceItem.create(invoice_item_params)
      end
    end
  end

  def year
    if !date.nil?
      date.year
    else
      time = Time.new
      time.year
    end
  end

  def next_number user ,year

    #TODO, exception if not year

    number = Invoice.maximum(:number, :conditions => ["YEAR(date)=? AND user_id=?", year, user.id])
    return (!number.nil? ? number+1 : 1)
  end

  def number_year
    number.to_s + '/' + date.year.to_s
  end


  ### for calculate amounts

  def base_amount

    base = 0
    
    invoice_items.each do |invoice_item|
      base = base + invoice_item.base_amount
    end

    return base
  end

  def vat_amount
    if base_amount.nil? || vat.nil?
      return 0;
    end
    ((base_amount * vat) / 100)
  end

  def irpf_amount
    if base_amount.nil? || irpf.nil?
      return 0;
    end

    ((base_amount * irpf) / 100)
  end

  def total_amount
    ((base_amount + vat_amount) - irpf_amount)
  end
  ############################################


  ### for filter invoices

  def self.filter_invoices user, month, year, customer_id


    invoices = Invoice.where('user_id=? AND YEAR(date)=?', user.id, year)

    if !month.nil? && month.to_i>0 && month.to_i<13
      invoices = invoices.where('MONTH(date)=?', month)
    end

    if !customer_id.nil? && customer_id.to_i>0
      invoices = invoices.where(:customer_id => customer_id)
    end

    return invoices
  end
  ############################################

  def to_invoice_html
    haml_template = "#{Rails.root}/app/views/invoices/show.html.haml"
    engine = Haml::Engine.new(IO.read(haml_template))
    invoice_html = engine.render(Object.new, {:invoice => self})
    return invoice_html
  end

  def to_invoice_pdf
    invoice_html = self.to_invoice_html
    invoice_pdf = PDFKit.new(invoice_html, :page_size => "A4").to_pdf
    return invoice_pdf
  end
end
