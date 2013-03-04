class InvoiceNumberValidator < ActiveModel::EachValidator

  # 
  # número de factura único por año
  # Valida que el número de factura insertado no exista ya en el año de esta factura
  # 
  def validate_each(record, attribute, value)

    if !record.date.nil?
      if record.id.nil?
        count_invoices = Invoice.count(:id, :conditions => ['user_id=? AND number=? AND YEAR(date)=?', 
                                                record.user.id, 
                                                record.number, 
                                                record.date.year])
      else
        count_invoices = Invoice.count(:id, :conditions => ['user_id=? AND number=? AND YEAR(date)=? AND id<>?', 
                                                record.user.id, 
                                                record.number, 
                                                record.date.year,
                                                record.id])
      end

      if count_invoices>0
        record.errors[attribute] = 'number_repeat'
      end
    end
  end
end
