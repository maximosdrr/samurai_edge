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
	print("ok 1")
	
func _ready():
	super._ready()
	self.attack.attack_parried_detected.connect(_handle_parry_attack1)
	print("Player", attack.attack_parried_detected.get_connections())
	self.playerCameraShaker = PlayerCameraShaker.new(self, camera)
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	movement.add_gravity(delta);
	movement.move_x(direction)
	
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		movement.jump(delta)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
	if Input.is_action_just_pressed("parry"):
		parry.parry()
