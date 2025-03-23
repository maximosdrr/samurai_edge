extends Node

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		MultiplayerManager.become_host()
	else:
		if MultiplayerManager.host_mode_enabled:
			MultiplayerManager.become_host()
		else:
			MultiplayerManager.join()
		
