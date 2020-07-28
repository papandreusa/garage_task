class TasksController < StandardController

  private
  def set_rendering_templates
    super
    @index_template = "index"
    @index_table_template = "_index_table"
    @new_template = "new"
    @edit_template = "edit"
    @show_template = "show"
    @instance_template = "_instance"
    @form_template = "_form"
   end
end
