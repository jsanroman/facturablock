class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_preferences

  include ActionView::Helpers::NumberHelper


  def index
    @year = (!params[:year].nil? ? params[:year] : Time.now.year)
    @month = params[:month]
    @customer_id = params[:customer_id]

    @invoices = Invoice.filter_invoices(current_user, @month, @year, @customer_id)

    @customers = Customer.all

    date_first_invoice = Invoice.minimum(:date)
    year_to = (date_first_invoice.nil? ? Time.now.year : date_first_invoice.year)

    # Years for select, from the current year to year first invoice
    @years = Time.now.year.downto(year_to).to_a
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @customers = current_user.customers
  end

  def new
    @invoice = Invoice.new
    @invoice.number   = @invoice.next_number(current_user, @invoice.year)
    @invoice.date     = @invoice.date = Time.now
    @invoice.vat      = current_user.preference.vat_default
    @invoice.irpf     = current_user.preference.irpf_default

    @customers = current_user.customers
  end

  def create
    begin
      params[:invoice][:date] = Date::strptime(params[:invoice][:date],"%d/%m/%Y")
    rescue
    end

    @invoice = Invoice.secure_create current_user, params[:invoice], params[:invoice_items]

    if @invoice.valid?
      redirect_to edit_invoice_path(@invoice), :notice => I18n.t('messages.success')
    else
      flash[:error] = I18n.t('errors.errors.template.body')

      @customers = current_user.customers
      render :new
    end
  end

  def update
    begin
      params[:invoice][:date] = Date::strptime(params[:invoice][:date],"%d/%m/%Y")
    rescue
    end

    @customers = current_user.customers

    @invoice = Invoice.secure_update params[:invoice], params[:invoice_items]

    if @invoice.valid?
      redirect_to edit_invoice_path(@invoice.id), :notice => I18n.t('messages.success')
    else
      flash[:error] = I18n.t('errors.errors.template.body')
      render :edit
    end
  end

  def destroy
    Invoice.secure_remove(params[:id])

    redirect_to invoices_path, :notice => I18n.t('messages.success_remove')
  end

  def pdf
    @invoice = Invoice.find(params[:id])

    # get invoice html
    haml_template = "#{Rails.root}/app/views/invoices/pdf.html.haml"
    engine        = Haml::Engine.new(IO.read(haml_template))
    invoice_html  = engine.render(Object.new, {:invoice => @invoice, :current_user => current_user, :number_to_currency => method(:number_to_currency)})

    # get invoice pdf
    invoice_pdf   = PDFKit.new(invoice_html, :page_size => "A4").to_pdf

    send_data invoice_pdf, :filename => "#{@invoice.number}.pdf", :type => "application/pdf", :disposition  => "attachment"
  end

end
