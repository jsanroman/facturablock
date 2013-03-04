PDFKit.configure do |config|
  if (Rails.env.development?)
    config.wkhtmltopdf = '/Users/javi/.rvm/gems/ruby-1.8.7-p370/bin/wkhtmltopdf'
  elsif (Rails.env.production?)
    config.wkhtmltopdf = '/usr/bin/wkhtmltopdf'
  end

  config.default_options = {
    :encoding=>"UTF-8",
    :page_size => "A4",
    :print_media_type => true
  }

#  config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end