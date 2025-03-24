extends Node

func generate_room_code(length := 6) -> String:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var code := ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in length:
		code += chars[rng.randi_range(0, chars.length() - 1)]
	
	return code
