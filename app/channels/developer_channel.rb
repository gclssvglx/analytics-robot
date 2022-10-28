class DeveloperChannel < ApplicationCable::Channel
  def subscribed
    stream_from "developer_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
