extends Character

class_name Player

var jump_force = -400
var speed = 200
var attack_damage = 100
var health = 1000

func _init():
	super(jump_force, speed, attack_damage, health)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	movement.add_gravity(delta);
	movement.move_x(direction)
	
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		movement.jump(delta)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
