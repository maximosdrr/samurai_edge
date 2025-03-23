extends Node2D

const SERVER_PORT = 8083

var player_scene = preload("res://Scenes/Core/player.tscn")
var _players_spawn_node: Node2D
var host_mode_enabled = false
var SERVER_IP = ""

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		call_deferred("_load_game_scene")

func _load_game_scene():
	var error = get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	if error != OK:
		print("Erro ao trocar de cena:", error)

func become_host():
	print("start hosting!", get_tree().get_current_scene())
	print(get_tree().get_current_scene().name)
	_players_spawn_node = get_tree().get_current_scene().get_node("SpawnPoint")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	if not OS.has_feature("dedicated_server"):
		_add_player_to_game(1)
	
func join():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
func _add_player_to_game(id: int):
	print("Player joined the game!", id)
	
	var player_to_add: Player = player_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	_players_spawn_node.add_child(player_to_add, true)

func _del_player(id: int):
	print("Player %s left the game!", % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
	
