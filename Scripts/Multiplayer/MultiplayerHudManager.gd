extends Node

@onready var multiplayer_hud: Control = $MultiplayerHud

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		MultiplayerManager.become_host()

func _on_become_host_pressed() -> void:
	multiplayer_hud.hide()
	MultiplayerManager.become_host()


func _on_join_pressed() -> void:
	multiplayer_hud.hide()
	MultiplayerManager.join()
