class FakerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "faker_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
