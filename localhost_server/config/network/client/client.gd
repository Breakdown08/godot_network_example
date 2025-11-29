class_name Client extends Button

@onready var timer:Timer = $timer

var peer:PacketPeerUDP = null
var data:Dictionary


func  _ready() -> void:
	text = str(data.get("id", "")).split(":")[1]
	pressed.connect(func():
		ClientInfo.instance.update(data)
	)
	timer.timeout.connect(Server.instance.client_disconnected.emit.bind(peer))
	timer.start()


func on_client_info_updated(client:PacketPeerUDP, new_data:Dictionary):
	if peer == client: 
		data = new_data
		timer.start()


func on_client_disconnected(client:PacketPeerUDP):
	if peer == client: queue_free()
