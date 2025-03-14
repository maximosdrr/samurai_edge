extends Character

class_name Enemy

var jump_force = -400
var speed = 200
var attack_damage = 300
var health = 1000

func _init():
	super(jump_force, speed, attack_damage, health)
	
func _physics_process(delta: float) -> void:
	movement.add_gravity(delta);

func _process(delta):
	pass
