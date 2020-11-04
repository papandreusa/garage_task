###################################################################
module InstanceMethods

# -------------------------
	def attr_value(attr_name)

		self.instance_eval &self.class.attr_show_method(attr_name)
	end
# #----------------------------
# 	def authorized(user_id)
#
# 		self
# 	end
#----------------------------
end

# ##################################################################

# ##################################################################
module ClassMethods


	def load_model_config
		require 'yaml'
		# @logger = Logger.new STDOUT
		# logger.info "load config for model #{self.name}".green
		model_config_file = "app/models/config/#{self.name.underscore}.yml"
		model_config = YAML.load_file("app/models/config/default.yml") || {}
		model_config = model_config.merge YAML.load_file(model_config_file) if File.exists?(model_config_file)
		@model_config = model_config.deep_symbolize_keys
	end

	def instance_name
		model_config[:instance_name] || self.name.underscore
	end

	def collection_name
		model_config[:collection_name] || self.name.underscore.pluralize
	end

	def instance_rendering_name
		model_config[:instance_rendering_name] || self.name.scan(/[A-Z][a-z]*/).join(" ")
	end

	def collection_rendering_name
		model_config[:collection_rendering_name] || self.name.scan(/[A-Z][a-z]*/).join(" ").pluralize
	end

	def model_config
		@model_config ||= load_model_config
	end

	def trusted_params
		model_config.fetch(:trusted_params, [])
		# raise MethodNotImplemented
	end

	def index_attrs
		model_config.fetch(:index_attrs, [:id])
		# raise MethodNotImplemented
	end

	def show_attrs
		model_config.fetch(:show_attrs, [:id])
		# raise MethodNotImplemented
	end

	def json_attrs
		model_config.fetch(:json_attrs, [:id] + show_attrs)
		# raise MethodNotImplemented
	end

	def get_has_many_assoc_names
		model_config[:has_many_assocs] || []
		# raise MethodNotImplemented
	end

	def get_association(assoc_name)
		reflect_on_all_associations(:has_many).select{|a| a.name == assoc_name.to_sym}.first
		# raise MethodNotImplemented
	end

	def belongs_to_assoc_names
		[]
	end

	def attrs_config
		model_config.fetch(:attrs_config, {})
		# raise MethodNotImplemented
	end

	def attr_fetch(attr_name, key)
		attrs_config.fetch(attr_name.to_sym, {})[key.to_sym]
	end

	def attr_show_method(attr_name)
		attrs_config.fetch(attr_name.to_sym, {}).fetch(:show_method, attr_name.to_sym).to_sym
	end

	def attr_name(attr_name)
		attrs_config.fetch(attr_name.to_sym, {}).fetch(:name, attr_name.to_s)
	end

# 	def authorized_scope(user_id)
# 		raise Errors::UnauthorizedAccessException
# 	end

end

# #############################################################################

# #############################################################################

module StandardModelPatch

	include InstanceMethods

	def self.included(base)

		base.extend ClassMethods
	end


end
