extends Character

class_name Enemy

func _physics_process(delta: float) -> void:
	movement.add_gravity(delta);

func _process(delta):
	pass
