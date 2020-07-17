require 'colorized_string'

class ColorKeyValue < Lograge::Formatters::KeyValue
	
  FIELDS_COLORS = {
    method: :light_yellow,
    path: :light_cyan,
    format: :white,
    controller: :light_magenta,
    action: :light_green,
    status: :light_yellow,
    duration: :light_magenta,
    view: :light_magenta,
    db: :light_magenta,
    time: :cyan,
    ip: :red,
    host: :red,
    params: :light_green,
    default: :white
  }

  def format(key, value)
    color = FIELDS_COLORS[key] || :default
    # ColorizedString.new(line).public_send(color)
    # line = super(key, value)
    line = super(ColorizedString.new(key.to_s).public_send(:green), ColorizedString.new(value.to_s).public_send(color))
  end
end