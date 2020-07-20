class TasksController < StandardController

  private
  def set_rendering_templates
    super
    @index_table_template = "_index_table"
    @new_template = "new"
    @edit_template = "edit"
    @show_template = "show"
   end
end
