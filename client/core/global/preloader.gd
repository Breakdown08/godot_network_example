extends Node

const CLIENT:PackedScene = preload("res://core/lobby/client/client.tscn")
const NETWORK_INTERFACE_LOCALHOST:PackedScene = preload("res://core/lobby/network_interfaces/network_localhost/network_localhost.tscn")
const NETWORK_INTERFACE_LAN:PackedScene = preload("res://core/lobby/network_interfaces/network_lan/network_lan.tscn")
const CONSOLE_TAB_WHISP:PackedScene = preload("res://core/console/tabs/tab_whisp/tab_whisp.tscn")
const CONSOLE_TAB_ROOM:PackedScene = preload("res://core/console/tabs/tab_room/tab_room.tscn")
