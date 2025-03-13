extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float):
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func take_damage():
	animated_sprite_2d.play("take_damage")
