class InfoTaskChannel < ApplicationCable::Channel
  def subscribed
    stream_from "info_task_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
