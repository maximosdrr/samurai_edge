extends BaseCharacter

class_name Player

var jump_force = -300
var speed = 200
var attack_damage = 300
var health = 1000

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSyncronizer.set_multiplayer_authority(id)

var do_jump = false
var _is_on_floor = true
var do_dash = false
var _current_state = CharacterState.States.IDLE
var _asset_direction = CharacterState.Direction.Left
var do_attack = false
var do_parry = false

@onready var camera: Camera2D = $Camera2D
var playerCameraShaker: PlayerCameraShaker
var self_attack: CharacterAttack

func _init():
	super(jump_force, speed, attack_damage, health)

func _ready():
	super._ready()
	PlayerCameraShaker.new(self, camera)
	self.state.character_state_change.connect(_update_state)
	self.state.character_direction_change.connect(_update_asset_direction)
	
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
func _update_asset_direction(direction):
	_asset_direction = direction
	
func _update_state(state):
	_current_state = state
	
func _physics_process(delta: float) -> void:
	
	if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
		self.animator.play_animation(_current_state)
		self.animator.flip_sprite(_asset_direction)
	
	if not multiplayer.is_server():
		return
	
	movement.add_gravity(delta);
	var direction = %InputSyncronizer.input_direction
	movement.move_x(direction)
	
	if do_jump and self.is_on_floor():
		movement.jump(delta)
		do_jump = false
	
	if do_dash and self.is_on_floor():
		dash.dash()
		do_dash = false
	
func _process(delta):
	if do_attack and is_multiplayer_authority():
		attack.attack()
		do_attack = false
	if do_parry and is_multiplayer_authority():
		parry.parry()
		do_parry = false
	
