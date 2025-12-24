extends ConsoleTab


func _ready():
	name = "General"
	EventBus.general_message.connect(on_message)


func _on_button_send_pressed(): pass
