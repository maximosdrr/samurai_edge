extends Node2D

const SERVER_PORT = 8083

var player_scene = preload("res://Scenes/Core/player.tscn")
var _players_spawn_node: Node2D
var host_mode_enabled = false
var SERVER_IP = "127.0.0.1"

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		print("becoming host")
		become_host()
	else:
		print("Join to the server")
		join()

func become_host():
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)

	
func join():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
func _peer_connected(id: int):
	print("Player joined the game!", id)
	
func _peer_disconnected(id: int):
	print("Player %s left the game!", % id)
