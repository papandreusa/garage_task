

Rails.application.configure do
	config.lograge.enabled = false
  config.lograge.formatter = ColorKeyValue.new
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      params: event.payload[:params].except(*exceptions)
    }
  end
end
