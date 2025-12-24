extends ConsoleTab


func _ready():
	name = "room"


func _on_button_send_pressed():
	prints("Room send", input.text)
