extends Control

@onready var lobby:Lobby = $margin/panel/zones/lobby
@onready var client:Client = $client
@onready var id_label:Label = $margin/panel/zones/id
@onready var console:Console = $margin/panel/zones/console

@export var localhost_mode = false


func _ready() -> void:
	client.id_updated.connect(_on_client_id_updated)
	client.start(localhost_mode)
	lobby.start(localhost_mode)


func _on_client_id_updated(id:String):
	lobby.client_id = id
	id_label.text = id
	console.client_id = id
