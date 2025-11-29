extends Control

@onready var server:Server = $server
@onready var lobby:Lobby = $panel/margin/body/content/lobby


func _ready() -> void:
	server.start()
	lobby.start()
