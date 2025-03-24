# Lobby.gd
extends Node2D

@onready var room_list: ItemList = $Control/RoomList
@onready var create_room: Button = $Control/CreateRoom
@export var room_to_be_created = ""

var game_scene = preload("res://Scenes/Game.tscn")
var game_wrapper = preload("res://Scenes/GameWrapper.tscn")

var rooms: Array[String] = []

func _on_create_room_pressed():
	var room_code = MultiplayerUtils.generate_room_code()
	_update_room_list_rpc.rpc(room_code)
	
@rpc("any_peer", "call_local") # Usado quando quero chamar o cliente e o servidor para serem notificados ao mesmo tempo
func _update_room_list_rpc(room_code: String):
	room_to_be_created = room_code
	_add_new_room()

func _add_new_room():
	room_list.add_item(room_to_be_created)
	rooms.append(room_to_be_created)
	
	var game_to_add = game_scene.instantiate()
	game_to_add.name = room_to_be_created
	game_wrapper.add_child(game_to_add)

func _on_room_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print(rooms[index])
