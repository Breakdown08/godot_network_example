class_name ConsoleTabWhisp extends ConsoleTab

var target_id:String = ""
var client_id:String = ""

var peer:PacketPeerUDP


func _ready():
	peer = PacketPeerUDP.new()
	var ip_port:Array = target_id.split(":")
	var port = int(ip_port[1])
	var address = ip_port[0]
	peer.bind(0)
	peer.set_dest_address(address, port)


func _on_button_send_pressed():
	on_message("you", input.text)
	peer.put_packet(str("%s%s%s" % [
			Client.MESSAGE_CLIENT_PASSWORD, 
			Client.MESSAGE_DELIMITER, 
			JSON.stringify({
				Client.CLIENT_MESSAGE_FROM: client_id,
				Client.CLIENT_MESSAGE_TO: target_id,
				Client.CLIENT_MESSAGE: input.text
			})
		]
	).to_utf8_buffer())
