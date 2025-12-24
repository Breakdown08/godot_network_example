class_name NetworkInterfaceLocalhost extends NetworkInterface

@onready var discovery_timer:Timer = $discovery_timer

const LOCALHOST:String = "127.0.0.1"

const DISCOVERY_PASSWORD:String = "DnAGD"
const DISCOVERY_DELIMITER:String = "|"

const DISCOVERY_CLIENTS:String = "clients"

const HOST_PORT:int = 4242

var connection:PacketPeerUDP = PacketPeerUDP.new()


func _ready():
	discovery_timer.timeout.connect(client_data_requested.emit.bind(self))


func create():
	connection.bind(0, LOCALHOST)
	connection.connect_to_host(LOCALHOST, HOST_PORT)
	set_process(true)
	client_data_requested.emit(self)
	discovery_timer.start()


func discovery(data:Dictionary):
	data[Lobby.CLIENT_DATA_USER_NAME] = "virtual_device"
	connection.put_packet(str("%s%s%s" % [
			DISCOVERY_PASSWORD, 
			DISCOVERY_DELIMITER, 
			JSON.stringify(data)
		]
	).to_utf8_buffer())
	#EventBus.general_message.emit("[DISCOVERY_LOCALOST]: %s" % JSON.stringify(data))


func _process(delta):
	while connection.get_available_packet_count() > 0:
		var packet:PackedByteArray = connection.get_packet()
		var string_data:String = packet.get_string_from_utf8()
		if string_data.begins_with(DISCOVERY_PASSWORD):
			var data:Dictionary = JSON.parse_string(string_data.split(DISCOVERY_DELIMITER)[1])
			if data.has(DISCOVERY_CLIENTS):
				var list:Dictionary[String, Dictionary] = {}
				for object in data.get(DISCOVERY_CLIENTS):
					list[object[Lobby.CLIENT_DATA_ID]] = object
				clients_list_updated.emit(list)
			else:
				client_data_updated.emit(data)
