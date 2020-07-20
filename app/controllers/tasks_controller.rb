class TasksController < StandardController

  private
  def set_rendering_templates
    super
    @index_table_template = "_index_table"
  end
end
