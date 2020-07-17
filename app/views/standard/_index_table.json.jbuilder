json.data   do
	json.array! collection_x, partial: "standard/instance", as: :instance
end
json.model model.name
json.collection_name model.collection_name
json.total collection_x.count
json.url polymorphic_url([parent_instance, model.collection_name], format: :json)
