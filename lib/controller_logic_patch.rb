load 'authorization'
require 'presentation'

module ControllerLogicPatch

private

	def get_model
		controller_name.classify.constantize
	end

	def authorize_access!()
			# authorization = Authorization.new(current_user, @model, @instance, @parent_instance)
			return true if @authorization.public_send("#{@_action_name}?")
			raise Errors::UnauthorizedAccessException
	end

	def init_params
		Hash.new
	end

	def instance_params
    params.fetch(@model.instance_name, {}).permit(@model.trusted_params)
  end

	def set_parent_instance
		return if params[:parent].nil?
		parent_model = Kernel.const_get(params[:parent])
    # @parent_instance = parent_model.find(params["#{params[:parent].downcase}_id"])
    parent_model.find(params["#{params[:parent].downcase}_id"])
		# @parent_assoc_name = parent_assoc_name
  end

	def set_instance
    !!@parent_instance ? @parent_instance.public_send(parent_assoc_name).find(params[:id]) : @model.find(params[:id])
  end

	def set_collection
		# authorization = Authorization.new(current_user, @model, @instance, @parent_instance)
		collection = @parent_instance ? @parent_instance.public_send(parent_assoc_name) : @authorization.authorize_scope(@model.all)
		collection = collection.includes(@model.belongs_to_assoc_names)
		collection
	end
# ------------------------------------------------------------------
	def create_instance(attrs = nil)

		!!@parent_instance ? @parent_instance.public_send(parent_assoc_name).build(attrs) : @model.new(attrs)
	end
# ------------------------------------------------------------------
	# def set_rendering_templates
  #
	# 	@index_template = "standard/index"
	# 	@index_table_template = "standard/_index_table"
	# 	@show_template = "standard/show"
	# 	@edit_template = "standard/edit"
	# 	@new_template = "standard/new"
	# 	@instance_template = "standard/_instance"
	# 	@form_template = "standard/_form"
	# 	@xhr_new_template = "standard/_form"
	# 	@xhr_edit_template = "standard/_form"
	# 	@xhr_after_create_template = "standard/_index_table"
	# 	@xhr_after_update_template = "standard/_index_table"
	# 	@xhr_after_delete_template = "standard/_index_table"
	# end
# #-----------------------------------------------------------------
# 	def set_associated_variables
#
# 		@model.get_has_many_assoc_names&.each { |t|
# 			@instance_variable_set("@#{t}", @instance.public_send(t))
# 		}
# 	end

# ----------------------------------------------------
	def parent_assoc_name

		params[:assoc] || params[:controller]
	end
# ---------------------------------------------------------------


end
