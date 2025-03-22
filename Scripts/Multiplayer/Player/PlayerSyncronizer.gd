extends MultiplayerSynchronizer

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		move_x.rpc(direction)
	
	if Input.is_action_just_pressed("jump"):
		jump.rpc(delta)


@rpc("call_local")
func jump(delta):
	if multiplayer.is_server():
		player.action_queue.enqueue(PlayerActionQueue.ActionEnum.JUMP, [delta], true)

@rpc("call_local")
func move_x(direction):
	if multiplayer.is_server():
		player.action_queue.enqueue(PlayerActionQueue.ActionEnum.RUN, [direction], true)
