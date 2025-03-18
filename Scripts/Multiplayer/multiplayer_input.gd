extends MultiplayerSynchronizer

var input_direction: int
@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		
	input_direction = Input.get_axis("move_left", "move_right")

func _physics_process(delta: float) -> void:
	input_direction = Input.get_axis("move_left", "move_right")
	player.movement.move_x(input_direction)
	
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	if Input.is_action_just_pressed("dash"):
		dash.rpc()
		
func _process(delta: float) -> void:
	if  Input.is_action_just_pressed("attack"):
		attack.rpc()
	if Input.is_action_just_pressed("parry"):
		parry.rpc()
	if Input.is_action_just_pressed("die"):
		die.rpc()
	if player.player_hp <= 0:
		die.rpc()

func _on_character_die():
	print("calls")
	die.rpc()

@rpc("call_local")
func attack():
	if multiplayer.is_server():
		player.do_attack = true

@rpc("call_local")
func parry():
	if multiplayer.is_server():
		player.do_parry = true

@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true

@rpc("call_local")
func dash():
	if multiplayer.is_server():
		player.do_dash = true

@rpc("call_local")
func die():
	if multiplayer.is_server():
		player.player_is_dead = true
