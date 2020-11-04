class ProjectsController < StandardController

# after_action  :broadcast_to_info_channel, only: [:create, :destroy]

def create
  super
end

private

	def init_params
		{ author_id: current_user.id }
  end

  def broadcast_to_info_channel
    ActionCable.server.broadcast "info_channel", project_count: @model.count
  end
end
