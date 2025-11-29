class_name Server extends Node

static var instance:Server

var connection = UDPServer.new()
var clients:Dictionary[PacketPeerUDP, Dictionary] = {}

const DISCOVERY_DELIMITER:String = "|"
const DISCOVERY_PASSWORD:String = "DnAGD"

const PORT:int = 4242

signal client_connected(client:PacketPeerUDP, data:Dictionary)
signal client_disconnected(client:PacketPeerUDP)
signal client_info_updated(client:PacketPeerUDP, data:Dictionary)


func _ready():
	set_process(false)
	instance = self
	client_info_updated.connect(_on_client_info_updated)
	client_connected.connect(_on_client_connected)
	client_disconnected.connect(_on_client_disconnected)
	connection.listen(PORT)


func start():
	set_process(true)


func _process(_delta):
	_check_new_connections()
	_poll()


func _check_new_connections():
	if connection.is_connection_available():
		var client:PacketPeerUDP = connection.take_connection()
		var packet:PackedByteArray = client.get_packet()
		var string_client_data:String = packet.get_string_from_utf8()
		if string_client_data.begins_with(DISCOVERY_PASSWORD): 
			client_connected.emit(client, _parse_client_data(string_client_data))


func _poll():
	connection.poll()
	for client in clients.keys():
		while client.get_available_packet_count():
			client_info_updated.emit(client, _parse_client_data(client.get_packet().get_string_from_utf8()))


func _parse_client_data(string_data:String) -> Dictionary:
	var obj:Dictionary = {}
	var data:Dictionary = JSON.parse_string(string_data.split(DISCOVERY_DELIMITER)[1])
	ClientInfo.instance.client_data_structure.keys()
	for key in data.keys():
		if key in ClientInfo.instance.client_data_structure.keys():
			var variant_value = data[key]
			match ClientInfo.instance.client_data_structure[key]:
				TYPE_INT:
					obj[key] = int(variant_value)
				TYPE_STRING:
					obj[key] = str(variant_value)
				TYPE_BOOL:
					obj[key] = bool(variant_value)
	return obj


func _on_client_connected(client:PacketPeerUDP, data:Dictionary):
	clients[client] = data
	_send_actual_clients_list()


func _on_client_disconnected(client:PacketPeerUDP):
	clients.erase(client)
	_send_actual_clients_list()


func _on_client_info_updated(client:PacketPeerUDP, data:Dictionary):
	clients[client] = data
	for peer in clients.keys():
		if peer != client: peer.put_packet(
			str("%s%s%s" % [
				DISCOVERY_PASSWORD, 
				DISCOVERY_DELIMITER, 
				JSON.stringify(data)]
			).to_utf8_buffer()
		)


func _send_actual_clients_list():
	var _clients:Array[Dictionary] = []
	for object in clients.keys():
		_clients.append(clients[object])
	var response:String = "%s%s%s" % [
		DISCOVERY_PASSWORD, 
		DISCOVERY_DELIMITER, 
		JSON.stringify({"clients" : _clients})
	]
	for peer in clients.keys():
		peer.put_packet(response.to_utf8_buffer())
