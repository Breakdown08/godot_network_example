class_name Console extends Control

@onready var tabs:TabContainer = $margin/tabs

var client_id:String = ""


func _ready():
	EventBus.whisp_to.connect(_on_whisp_to)
	EventBus.client_message.connect(_on_client_message)


func start():
	pass


func _on_whisp_to(id_to:String):
	var tab_name:String = _get_tab_name(id_to)
	if !_is_tab_exists(tab_name): _create_tab(id_to, tab_name)


func _on_client_message(id_from:String, message:String):
	var tab_name:String = _get_tab_name(id_from)
	if !_is_tab_exists(_get_formatted_id(id_from)): _create_tab(id_from, tab_name)
	var whisp = get_node("margin/tabs/%s" % tab_name) as ConsoleTabWhisp
	whisp.on_message("whisper", message)


func _get_formatted_id(id:String) -> String:
	var formatted_id:String = id.replace(".", "_")
	return formatted_id.replace(":", "_")


func _get_tab_name(id:String) -> String:
	return "whisp_%s" % _get_formatted_id(id)


func _create_tab(id:String, tab_name:String):
	var tab = Preloader.CONSOLE_TAB_WHISP.instantiate() as ConsoleTabWhisp
	tab.client_id = client_id
	tab.target_id = id
	tab.name = tab_name
	tabs.add_child(tab)


func _is_tab_exists(tab_name:String):
	var result:Node = tabs.get_node_or_null(tab_name)
	return false if result == null else true
