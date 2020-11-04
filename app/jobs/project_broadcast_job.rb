class ProjectBroadcastJob < ApplicationJob
  queue_as :default

  def perform(project_model_name)
    ActionCable.server.broadcast "info_channel", project_count: "<b>#{project_model_name.constantize.count}</b>"
  end

  private

 def render(project_model_name)
   ProjectController.render inline: "<b>#{project_model_name.constantize.count}</b>"
 end
end
