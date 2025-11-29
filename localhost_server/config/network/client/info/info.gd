class_name ClientInfo extends Panel

@onready var _list:VBoxContainer = $margin/list

const PROPERTY:PackedScene = preload("res://config/network/client/info/property/property.tscn")

static var instance:ClientInfo

@export var client_data_structure:Dictionary[String, Variant.Type]

var meta:Array[ClientInfoProperty]


func _ready():
	instance = self
	for key in client_data_structure.keys():
		var property = PROPERTY.instantiate() as ClientInfoProperty
		property.key = key
		_list.add_child(property)
		meta.append(property)


func update(data:Dictionary):
	if data.is_empty(): return
	for property in meta:
		property.new_value.emit(data[property.key])
