extends BaseCharacter

class_name Player

var jump_force = -250
var speed = 200
var attack_damage = 300
var health = 1000

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSyncronizer.set_multiplayer_authority(id)

@export var _action_queue: Array[Dictionary]:
	get:
		return self.action_queue.queue

@export var _state: CharacterState.States
@export var _direction: CharacterState.Direction
@export var _sfx_to_play = ""
@onready var camera: Camera2D = $Camera2D

var playerCameraShaker: PlayerCameraShaker
var self_attack: CharacterAttack
var action_queue: PlayerActionQueue

func _init():
	super(jump_force, speed, attack_damage, health)
	

func _handle_state_change(new_state):
	_state = new_state

func _handle_change_direction(new_direction):
	_direction = new_direction

func _handle_play_sound():
	if _sfx_to_play != "":
		self.audio_player.play_without_emit(_sfx_to_play)
		_sfx_to_play = ""

func _handle_update_sfx(sfx):
	_sfx_to_play = sfx
	
func _ready():
	super._ready()
	PlayerCameraShaker.new(self, camera)
	self.state.character_state_change.connect(_handle_state_change)
	self.state.character_direction_change.connect(_handle_change_direction)
	self.audio_player.sound_to_play.connect(_handle_update_sfx)
	self.action_queue = PlayerActionQueue.new()

	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false


func _physics_process(delta: float) -> void:
	self.animator.play_animation(_state)
	self.animator.flip_sprite(_direction)
	_handle_play_sound()
	movement.add_gravity(delta)
	
	if not multiplayer.is_server():
		return
	for action in _action_queue:
		match action["action"]:
			PlayerActionQueue.ActionEnum.JUMP:
				self.movement.jump(action["args"][0])
			PlayerActionQueue.ActionEnum.RUN:
				self.movement.move_x(action["args"][0])
			PlayerActionQueue.ActionEnum.PARRY:
				self.parry.parry()
			PlayerActionQueue.ActionEnum.ATTACK:
				self.attack.attack()
			PlayerActionQueue.ActionEnum.DASH:
				self.dash.dash()
			PlayerActionQueue.ActionEnum.IDLE:
				self.movement.stop()
		self.action_queue.dequeue()
