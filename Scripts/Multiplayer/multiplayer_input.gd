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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	if Input.is_action_just_pressed("dash"):
		dash.rpc()
		
@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true

@rpc("call_local")
func dash():
	if multiplayer.is_server():
		player.do_dash = true
