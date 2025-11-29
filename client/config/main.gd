extends Control

@onready var lobby:Lobby = $margin/panel/zones/lobby
@onready var console:Console = $margin/panel/zones/console

@export var localhost_mode = false


func _ready() -> void:
	console.start()
	lobby.start(localhost_mode)
