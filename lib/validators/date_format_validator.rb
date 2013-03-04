class DateFormatValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    begin
      date = Date::strptime(record.date.to_s,"%d/%m/%Y")
    rescue ArgumentError
      record.errors[attribute] = "date is invalid."
    end
  end
end