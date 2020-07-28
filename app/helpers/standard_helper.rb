module StandardHelper

  module ClassMethods
  end
# ----------------------------------------------------
  module InstanceMethods
		def get_model
			# raise Exception.new(:MethodNotImplemented)
			controller_name.classify.constantize
		end
# ----------------------------------------------------
# -------------------------------------------
	def get_parent_assoc_name
		params[:assoc] || params[:controller]
	end
# -------------------------------------------
#     def instance_path(record, parent: nil)
#
#         # !!parent ? [parent, record] : public_send("#{get_model.instance_name}_path", record)
#         !!parent ? [parent, record] : [record]
#     end
# # ----------------------------------------------------
#     def new_instance_path(parent: nil)
#         !!parent ? [:new, parent, get_parent_assoc_name.singularize] : public_send("new_#{get_model.instance_name}_path")
#     end
# # ----------------------------------------------------
#     def edit_instance_path(record, parent: nil)
#         !!parent ? [:edit, parent, record] : public_send("edit_#{get_model.instance_name}_path", record)
#     end
# # ----------------------------------------------------
#     def collection_path(parent:nil)
#       !!parent ? [parent, @parent_assoc_name] : public_send("#{get_model.collection_name}_path")
#     end

  end

end
