extends BaseCharacter

class_name Player

var jump_force = -300
var speed = 200
var attack_damage = 10
var health = 1000

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSyncronizer.set_multiplayer_authority(id)

var do_jump = false
var _is_on_floor = true
var do_dash = false

@onready var camera: Camera2D = $Camera2D
var playerCameraShaker: PlayerCameraShaker
var self_attack: CharacterAttack

func _init():
	super(jump_force, speed, attack_damage, health)

func _ready():
	super._ready()
	PlayerCameraShaker.new(self, camera)
	
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
	
func _physics_process(delta: float) -> void:
	movement.add_gravity(delta);
	
	if not multiplayer.is_server():
		return
		
	var direction = %InputSyncronizer.input_direction
	movement.move_x(direction)
	
	if do_jump and self.is_on_floor():
		movement.jump(delta)
		do_jump = false
	
	if do_dash and self.is_on_floor():
		dash.dash()
		do_dash = false

func _process(delta):
	if Input.is_action_just_pressed("attack") and is_multiplayer_authority():
		attack.attack()
	if Input.is_action_just_pressed("parry") and is_multiplayer_authority():
		parry.parry()
