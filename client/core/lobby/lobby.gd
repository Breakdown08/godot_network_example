class_name Lobby extends Control

@onready var clients:VBoxContainer = $margin/panel/scroll/clients

const CLIENT_DATA_STATUS:String = "status"
const CLIENT_DATA_IS_HOST:String = "is_host"
const CLIENT_DATA_ID:String = "id"
const CLIENT_DATA_USER_NAME:String = "user_name"

enum Status {TIMEOUT, ALIVE}

var id_table:Dictionary[String, LobbyClient]

var client_id:String

var interface:NetworkInterface


func start(localhost_mode:bool = false):
	interface = Preloader.NETWORK_INTERFACE_LOCALHOST.instantiate() if localhost_mode else Preloader.NETWORK_INTERFACE_LAN.instantiate()
	interface.id = client_id
	interface.client_data_requested.connect(_on_client_data_requested)
	interface.clients_list_updated.connect(_on_clients_list_updated)
	add_child(interface)
	interface.create()


func _on_client_data_requested(network_interface:NetworkInterface):
	network_interface.discovery(
			_create_client_data(
			client_id,
			"username",
			false
		)
	)


static func _create_client_data(id:String, user_name:String, is_host:bool) -> Dictionary:
	var device_data:Dictionary = {
		CLIENT_DATA_STATUS : Status.ALIVE,
		CLIENT_DATA_IS_HOST : is_host,
		CLIENT_DATA_ID : id,
		CLIENT_DATA_USER_NAME : user_name
	}
	return device_data


func _create_client(id:String, data:Dictionary) -> LobbyClient:
	var client:LobbyClient = Preloader.CLIENT.instantiate()
	client.id = id
	client.data = data
	interface.client_data_updated.connect(client.on_client_data_updated)
	return client


func _on_clients_list_updated(new_id_table:Dictionary[String, Dictionary]):
	var result:Dictionary[String, LobbyClient]
	for id in id_table.keys():
		if id in new_id_table.keys():
			id_table[id].on_client_data_updated(new_id_table[id])
			result[id] = id_table[id]
		else:
			id_table[id].queue_free()
	for id in new_id_table.keys():
		if not id in id_table.keys() and id != interface.id:
			var new_client:LobbyClient = _create_client(id, new_id_table[id])
			clients.add_child(new_client)
			result[id] = new_client
	id_table = result
