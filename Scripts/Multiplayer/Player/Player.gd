extends MultiplayerSynchronizer

class_name PlayerSyncronizer

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSyncronizer.set_multiplayer_authority(id)

@export var _action_queue: Array[Dictionary]:
	get:
		return self.action_queue.queue

@export var _state: CharacterState.States:
	get:
		return self.state.current_state

@onready var camera: Camera2D = $Camera2D

var playerCameraShaker: PlayerCameraShaker
var self_attack: CharacterAttack
var action_queue: PlayerActionQueue


func _ready():
	self.action_queue = PlayerActionQueue.new()

	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false


func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	
	animator.play_animation(_state)
	
	if _action_queue.size() == 0:
		self.movement.stop()
	
	movement.add_gravity(delta)
	
	for action in _action_queue:
		match action["action"]:
			PlayerActionQueue.ActionEnum.JUMP:
				self.movement.jump(action["args"][0])
			PlayerActionQueue.ActionEnum.RUN:
				self.movement.move_x(action["args"][0])
		self.action_queue.dequeue()
