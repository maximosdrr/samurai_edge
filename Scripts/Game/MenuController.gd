extends Node2D

@onready var http_request: HTTPRequest = $Control/HTTPRequest
@onready var create_game_code: LineEdit = $Control/CreateGameCode
@onready var create_game_label: Label = $Control/CreateGameLabel
@onready var join_game_code: LineEdit = $Control/JoinGameCode
@onready var join_game_label: Label = $Control/JoinGameLabel
@onready var create: Button = $Control/Create
@onready var join: Button = $Control/Join

var create_game_is_pressed = false
var join_game_is_pressed = false
var room_code = ""

func _on_unhide_create_pressed() -> void:
	create_game_is_pressed = true
	http_request.request_completed.connect(_on_request_completed)
	
	var error = http_request.request("https://ipinfo.io/json")
	
	if error != OK:
		print("Request failed: ", error)
	
	if join_game_is_pressed:
		_hide_join()
		join_game_is_pressed = false
	
	_show_create()

func _on_unhide_join_pressed() -> void:
	join_game_is_pressed = true
	
	if create_game_is_pressed:
		_hide_create()
		create_game_is_pressed = false
	_show_join()

func _hide_join():
	join_game_code.hide()
	join_game_label.hide()
	join.hide()
	
func _hide_create():
	create_game_code.hide()
	create_game_label.hide()
	create.hide()

func _show_join():
	join_game_code.show()
	join_game_label.show()
	join.show()

func _show_create():
	create_game_code.show()
	create_game_label.show()
	create.show()

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result == OK:
		var json = JSON.new()
		var parse_error = json.parse(body.get_string_from_utf8())
		
		if parse_error == OK:
			var parsed_data = json.data
			if parsed_data.has("ip"):
				room_code = parsed_data["ip"]
				create_game_code.text = room_code
				print("Your public IP is: ", room_code)
			else:
				print("Response does not contain 'ip'")
		else:
			print("Failed to parse JSON. Error: ", parse_error)
	else:
		print("HTTP request failed. Result: ", result)


func _on_create_pressed() -> void:
	if room_code != "":
		var error = get_tree().change_scene_to_file("res://Scenes/Game.tscn")
		MultiplayerManager.SERVER_IP = room_code
		MultiplayerManager.host_mode_enabled = true
		
		if error != OK:
			print("Erro ao trocar de cena: ", error)


func _on_join_pressed() -> void:
	if join_game_code.text != "":
		var error = get_tree().change_scene_to_file("res://Scenes/Game.tscn")
		MultiplayerManager.SERVER_IP = room_code
		MultiplayerManager.host_mode_enabled = false
		
		if error != OK:
			print("Erro ao trocar de cena: ", error)
