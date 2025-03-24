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
		_send_action.rpc(PlayerActionQueue.ActionEnum.RUN, [direction])
	else:
		_send_action.rpc(PlayerActionQueue.ActionEnum.IDLE, [])
	
	if Input.is_action_just_pressed("jump") and player.player_is_on_floor:
		_send_action.rpc(PlayerActionQueue.ActionEnum.JUMP, [delta])
	
	if Input.is_action_just_pressed("attack"):
		_send_action.rpc(PlayerActionQueue.ActionEnum.ATTACK, [])
	
	if Input.is_action_just_pressed("dash"):
		_send_action.rpc(PlayerActionQueue.ActionEnum.DASH, [])
	
	if Input.is_action_just_pressed("parry"):
		_send_action.rpc(PlayerActionQueue.ActionEnum.PARRY, [])

@rpc("call_local", "reliable")
func _send_action(action, params, avoid_duplicated_entry = true):
	if multiplayer.is_server():
		player.action_queue.enqueue(action, params, avoid_duplicated_entry)
