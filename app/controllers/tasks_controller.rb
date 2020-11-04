class TasksController < StandardController

after_action  :broadcast_to_info_task_channel, only: [:create, :destroy]

private
  def init
    if request.format.to_sym == :html && request.xhr?
      @presentation = AjaxPresentation.new(self, layout: false) do |template|
          template[:index] = "_index_table"
          template[:show] = "_instance"
          template[:new] = "_form"
          template[:edit] = "_form"
        end
    end
    super
  end

  def broadcast_to_info_task_channel
    ActionCable.server.broadcast "info_task_channel", task_count: @model.count, user: current_user, h: {a: 1, b: 2, c: 3}
  end
end
