class_name LobbyClient extends Control

@onready var master_tag:Label = $margin/props/master_tag
@onready var address:Label = $margin/props/id
@onready var status:Panel = $status
@onready var status_timer:Timer = $status_timer
@onready var menu:MenuButton = $margin/props/menu

enum PopupButton {WHISP, CONNECT_TO_ROOM}
const POPUP_BUTTON_MAP:Dictionary = {
	PopupButton.WHISP : "whisp",
	PopupButton.CONNECT_TO_ROOM : "connect to room",
}

var id:String = ""
var data:Dictionary = {}


func _ready():
	for item in POPUP_BUTTON_MAP.keys():
		menu.get_popup().add_item(POPUP_BUTTON_MAP[item])
	name = id
	address.text = id
	status_timer.timeout.connect(_on_status_timer_timeout)
	menu.get_popup().id_pressed.connect(_on_menu_id_pressed)


func on_client_data_updated(client_data:Dictionary):
	data = client_data
	if id == data[Lobby.CLIENT_DATA_ID]:
		match int(data[Lobby.CLIENT_DATA_STATUS]):
			Lobby.Status.TIMEOUT:
				status.modulate = Color.GRAY
			Lobby.Status.ALIVE:
				status.modulate = Color.GREEN
		master_tag.visible = false if !data[Lobby.CLIENT_DATA_IS_HOST] else true
		menu.get_popup().set_item_disabled(1, !master_tag.visible)


func _on_status_timer_timeout():
	prints()


func _on_menu_id_pressed(menu_id:int):
	match menu_id:
		PopupButton.WHISP:
			EventBus.whisp_to.emit(id)
		PopupButton.CONNECT_TO_ROOM:
			prints("...connect to room pressed...")
