class FakerChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # stop_all_streams
    stream_from "faker_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
