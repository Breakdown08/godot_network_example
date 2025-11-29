class_name Room extends Control

static var connection:PacketPeerUDP


func _ready():
	connection = PacketPeerUDP.new()


func start():
	connection.bind(0)
	connection.set_broadcast_enabled(true)
	connection.set_dest_address("255.255.255.255", connection.get_local_port())
