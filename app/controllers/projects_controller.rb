class ProjectsController < StandardController


	private

	def set_rendering_templates
		super
		@index_template = 'index'
		@index_table_template = "index"
		@show_template = 'show'
		@new_template = 'new'
		@edit_template = 'edit'
		@instance_template = "show"
		@form_template = "edit"
	end

	def instance_params
    super_params = super
		super.merge({author_id: current_user.id})
  end
end
