json.partial! partial: "standard/index_table", collection_x: @collection, model: @model, parent_instance: @parent_instance,  as: :instance
json.flash flash.to_h
json.status status
