extends Node2D

var peer = ENetMultiplayerPeer.new()
var PLAYER = preload("res://Scenes/Core/player.tscn")

# Dicionário para armazenar os jogadores conectados
var players = {}

@onready var camera_2d: Camera2D = $Camera2D
@onready var host: Button = $Host
@onready var join: Button = $Join

func _on_host_pressed():
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	# O host (servidor) também precisa ser um jogador
	_on_player_connected(multiplayer.get_unique_id())

func _on_join_pressed():
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer

# 🚀 O servidor adiciona um novo jogador e informa todos os clientes
func _on_player_connected(id):
	print("Novo jogador conectado:", id)
	
	# Adiciona ao dicionário de jogadores
	players[id] = true  # Apenas armazenamos o ID do jogador

	# O servidor informa todos os clientes para criarem o jogador
	rpc("_spawn_player", id)

	# Se um novo cliente se conectou, o servidor envia a lista de jogadores existentes para ele
	for player_id in players.keys():
		rpc_id(id, "_spawn_player", player_id)

# 🚀 O servidor avisa a todos os clientes quando um jogador desconecta
func _on_player_disconnected(id):
	print("Jogador saiu:", id)
	
	if id in players:
		players.erase(id)
		rpc("_despawn_player", id)

# 🚀 Função que será chamada em todos os clientes para criar um jogador
@rpc("any_peer", "call_local")
func _spawn_player(id):
	if has_node(str(id)):  # Evita criar duplicatas
		return
	
	var player = PLAYER.instantiate() as Player
	player.name = str(id)  # Nome único para cada jogador

	add_child(player)
	
	# Define a autoridade correta para o jogador
	player.set_multiplayer_authority(id)

	# Posição inicial
	player.position = Vector2(randi_range(365, 600), -40)

	# Se este jogador for o local, movemos a câmera para ele
	if multiplayer.get_unique_id() == id:
		camera_2d.reparent(player)
		host.queue_free()
		join.queue_free()

# 🚀 Função para remover um jogador desconectado
@rpc("any_peer", "call_local")
func _despawn_player(id):
	if has_node(str(id)):
		get_node(str(id)).queue_free()
