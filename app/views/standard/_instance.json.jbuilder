json.extract! instance, *instance.class.json_attrs
json.url polymorphic_url([@parent_instance, instance], format: :json)
model = instance.class
model.get_has_many_assoc_names&.each do |assoc_name|

    has_many_collection = instance.public_send(assoc_name)
    total_count = has_many_collection.count
	   json.set! assoc_name   do
			 assoc_class = model.get_association(assoc_name).klass
			 json.partial! partial: "standard/index_table", collection_x: has_many_collection, model: assoc_class, parent_instance: instance,  as: :instance

		# 	json.data do
		#     json.array! has_many_collection do |record|
		# 			json.extract! record, *record.class.json_attrs
		# 			json.url polymorphic_url([instance, record], format: :json)
		# 		end
		# 	end
		# 	json.total total_count
		# 	json.url polymorphic_url([instance, assoc_name], format: :json)
    end

end
