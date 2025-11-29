class_name ClientInfoProperty extends Control

@onready var key_node:Label = $key_value/key
@onready var type_bool_value:CheckBox = $key_value/value/type_bool
@onready var type_string_value:Label = $key_value/value/type_string
@onready var type_int_value:SpinBox = $key_value/value/type_int

var key:String = ""

signal new_value(data_variant)


func _ready() -> void:
	key_node.text = key
	var type = ClientInfo.instance.client_data_structure.get(key) as Variant.Type
	match type:
		TYPE_INT:
			type_int_value.show()
			new_value.connect(_on_new_int_value)
		TYPE_STRING:
			type_string_value.show()
			new_value.connect(_on_new_string_value)
		TYPE_BOOL:
			type_bool_value.show()
			new_value.connect(_on_new_bool_value)


func _on_new_int_value(value:int): type_int_value.value = value
func _on_new_string_value(value:String): type_string_value.text = value
func _on_new_bool_value(value:bool): type_bool_value.button_pressed = value
