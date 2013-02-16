require 'eventmachine'
require 'em-websocket'
require 'json'
require 'sqlite3'
@sockets = []
EventMachine.run do
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080,:debug => true) do |socket|
    socket.onopen do
      puts "new connection"
      puts socket
     # puts socket.methods.inspect
      puts socket.request["query"]["id"]
      @sockets << socket
    end
    socket.onmessage do |mess|
      #puts "I received message"
      #empls = JSON.parse(mess)
      #puts empls;
      #update_grid empls
     @sockets.each {|s| s.send mess}


    end
    socket.onclose do
      puts "closing connection"
      @sockets.delete socket
    end
  end



  def update_grid(message)
    ships = message['ships']
    value = ships[0]
    puts value

    dt = DateTime.now

    db = SQLite3::Database.new "development.sqlite3"
    sqlstring = "INSERT into grids (user_id,coordinate,ship_id,created_at,updated_at,alignment,ship_size,coordinate_x,coordinate_y,current_coordinate_x,current_coordinate_y)
VALUES (1,#{value['coordinate']},#{value['ship_id']},#{dt},#{dt},#{value['alignment']},#{value['ship_size']},#{value['coordinate_x']},#{value['coordinate_y']},#{value['current_coordinate_x']},#{value['current_coordinate_y']}});"
    puts sqlstring
    db.execute(sqlstring )
  end
end