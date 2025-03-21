extends BaseCharacter

class_name Player

var jump_force = -250
var speed = 200
var attack_damage = 10
var health = 1000

@onready var camera: Camera2D = $Camera
var playerCameraShaker: PlayerCameraShaker
var self_attack: CharacterAttack

func _init():
	super(jump_force, speed, attack_damage, health)

func _handle_parry_attack1():
	print("Character have died")

func _ready():
	super._ready()
	PlayerCameraShaker.new(self, camera)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	movement.add_gravity(delta);
	movement.move_x(direction)

	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		movement.jump(delta)

	if Input.is_action_just_pressed("dash") and self.is_on_floor():
		dash.dash()

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
	if Input.is_action_just_pressed("parry"):
		parry.parry()
