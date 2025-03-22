extends Node

func _ready() -> void:
	if MultiplayerManager.host_mode_enabled:
		MultiplayerManager.become_host()
	else:
		MultiplayerManager.join()
		
