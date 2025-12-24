class_name Client extends Node

const MESSAGE_CLIENT_PASSWORD = "clmsg"
const MESSAGE_DELIMITER:String = "|"

const CLIENT_MESSAGE:String = "message"
const CLIENT_MESSAGE_FROM:String = "from"
const CLIENT_MESSAGE_TO:String = "to"

signal id_updated(ip_port:String)

var connection:PacketPeerUDP

var id:String = ""


func _ready():
	connection = PacketPeerUDP.new()


func start(localhost_mode:bool = false):
	connection.bind(0)
	_set_broadcast()
	var ip:String = NetworkInterfaceLocalhost.LOCALHOST if localhost_mode else _get_local_ip_address()
	id = "%s:%s" % [ip, connection.get_local_port()]
	id_updated.emit(id)


func _get_local_ip_address() -> String:
	var local_ips = IP.get_local_addresses()
	for result in local_ips:
		if result.begins_with("192.168."):
			return result
	return ""


func _process(delta):
	while connection.get_available_packet_count() > 0:
		var packet:PackedByteArray = connection.get_packet()
		var string_data:String = packet.get_string_from_utf8()
		if string_data.begins_with(MESSAGE_CLIENT_PASSWORD):
			var data:Dictionary = JSON.parse_string(string_data.split(MESSAGE_DELIMITER)[1])
			EventBus.client_message.emit(
				data[CLIENT_MESSAGE_FROM], 
				data[CLIENT_MESSAGE]
			)


func _set_broadcast():
	connection.set_broadcast_enabled(true)
	connection.set_dest_address("255.255.255.255", connection.get_local_port())


func _set_target(ip:String, port:int):
	connection.set_dest_address(ip, port)
	connection.set_broadcast_enabled(false)
