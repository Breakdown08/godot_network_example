@abstract class_name ConsoleTab extends Control

@onready var console:TextEdit = $body/scroll/console
@onready var button_send:Button = $body/input/send
@onready var input:TextEdit = $body/input/input


func _init():
	ready.connect(_base_ready)


func on_message(from:String ,message:String):
	var unix_time:float = Time.get_unix_time_from_system()
	var time_dict:Dictionary = Time.get_datetime_dict_from_unix_time(int(unix_time))
	var time_string:String = "%s:%s" % [time_dict.hour, time_dict.minute]
	_write("%s [%s]: %s" % [time_string, from, message])


func _write(data):
	console.text += str(data) + "\n"


func _base_ready():
	button_send.pressed.connect(func():
		_on_button_send_pressed()
		input.text = ""
	)


@abstract func _on_button_send_pressed()
