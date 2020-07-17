json.errors @instance.errors
json.url public_send("#{@model.instance_name}_url", @instance, format: :json) unless @instance
json.status status