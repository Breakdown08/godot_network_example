class_name Client extends Control

@onready var master_tag:Label = $margin/props/master_tag
@onready var address:Label = $margin/props/id
@onready var status:Panel = $status
@onready var status_timer:Timer = $status_timer

var id:String = ""
var data:Dictionary = {}


func _ready():
	name = id
	address.text = id
	status_timer.timeout.connect(_on_status_timer_timeout)


func on_client_data_updated(client_data:Dictionary):
	data = client_data
	if id == data[Lobby.CLIENT_DATA_ID]:
		match int(data[Lobby.CLIENT_DATA_STATUS]):
			Lobby.Status.TIMEOUT:
				status.modulate = Color.GRAY
			Lobby.Status.ALIVE:
				status.modulate = Color.GREEN
		master_tag.visible = true if data[Lobby.CLIENT_DATA_IS_HOST] else false


func _on_status_timer_timeout():
	prints()
