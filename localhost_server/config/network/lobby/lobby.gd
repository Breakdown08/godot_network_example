class_name Lobby extends Panel

@onready var list:HFlowContainer = $scroll/margin/flow

const CLIENT:PackedScene = preload("res://config/network/client/client.tscn")


func start():
	Server.instance.client_connected.connect(_on_client_connected)


func _on_client_connected(client:PacketPeerUDP, data:Dictionary):
	var client_instance = CLIENT.instantiate() as Client
	client_instance.data = data
	client_instance.peer = client
	Server.instance.client_info_updated.connect(client_instance.on_client_info_updated)
	Server.instance.client_disconnected.connect(client_instance.on_client_disconnected)
	list.add_child(client_instance)
