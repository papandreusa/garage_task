json.data @instance, partial:  "standard/instance", as: :instance
json.model @model.name
json.instance_name @model.instance_name
json.flash flash.to_h
json.status status
