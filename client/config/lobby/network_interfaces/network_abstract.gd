@abstract class_name NetworkInterface extends Node


@abstract func create()

@abstract func discovery(data:Dictionary)

signal client_data_requested(interface:NetworkInterface)
signal clients_list_updated(new_id_table:Dictionary[String,Dictionary])
signal client_data_updated(data:Dictionary)

var id:String


func _init() -> void:
	ready.connect(func(): set_process(false))
