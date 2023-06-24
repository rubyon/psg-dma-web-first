require 'rubygems'
require 'websocket-client-simple'
require 'json'

def connect_websocket
  WebSocket::Client::Simple.connect('ws://127.0.0.1:3000/cable')
end

def subscribe_channel(ws)
  ws.on :open do
    # Send command to subscribe to ActionCable's specific channel after connect to socket
    ws.send({"command":"subscribe","identifier":"{\"channel\":\"ModbusChannel\"}"}.to_json)
  end
end

def send_message(ws, action, value)
  message = {
    command: 'message',
    identifier: '{"channel":"ModbusChannel"}',
    data: {
      action: action,
      value: value
    }.to_json
  }

  ws.send(message.to_json)
end

while true
  begin
    ws = connect_websocket

    # ws.on :message do |msg|
    #   puts msg.data
    # end

    ws.on :close do |e|
      p e
      break if e.code == 1000  # Exit the loop only if the connection is closed intentionally
    end

    # ws.on :error do |e|
    #   p e
    # end

    subscribe_channel(ws)

    i = 0
    loop do
      send_message(ws, 'modbus', i += 1)
      sleep(2)
    end
  rescue
    sleep(1)
    puts $!
  end
end
