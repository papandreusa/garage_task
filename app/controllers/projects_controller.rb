class ProjectsController < StandardController


	private

	def set_rendering_templates
		super
		@index_template = 'index'
		@index_table_template = "_index_table"
		@show_template = 'show'
	end

	def instance_params
    super_params = super
		super.merge({author_id: current_user.id})
  end
end
