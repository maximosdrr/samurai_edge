extends Character

class_name Player

var jump_force = -250
var speed = 200
var attack_damage = 10
var health = 1000

@onready var camera: Camera2D = $Camera

func _init():
	super(jump_force, speed, attack_damage, health)

func _ready():
	super._ready()
	var instance = PlayerCameraShaker.new(self, camera)
	add_child(instance)
	
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
