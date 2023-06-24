class ModbusChannel < ApplicationCable::Channel
  def subscribed
    puts "##### connected"
    stream_from 'modbus_channel'
  end

  def unsubscribed
    puts "##### disconnected"

    # Any cleanup needed when channel is unsubscribed
  end

  def modbus(data)
    ActionCable.server.broadcast("modbus_channel",data)
  end
end
