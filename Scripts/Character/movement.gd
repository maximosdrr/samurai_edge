# PlayerMovement.gd
extends Node

class_name CharacterMovement

var speed = 200
var jump_force = -400
var character: CharacterBody2D
var hitbox: CollisionShape2D

func _init(body: CharacterBody2D):
	character = body
	hitbox = character.get_node("HitBox").get_node("Area")

func process_movement(delta):
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		character.velocity.x = direction * speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)

	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = jump_force
	
	if not character.is_on_floor():
		character.velocity += character.get_gravity()  * delta
		
	_update_state()
	character.move_and_slide()

func _flip_hitbox(direction: CharacterState.Direction):
	if direction == CharacterState.Direction.Right:
		hitbox.position.x = 25.5
	else:
		hitbox.position.x = -23.5

func _update_state():
	if character.state.current_state == CharacterState.States.ATTACKING:
		return
	if character.velocity.x == 0 and character.is_on_floor():
		character.state.change_state(CharacterState.States.IDLE)
	if character.velocity.x > 0 and character.is_on_floor():
		character.state.change_direction(CharacterState.Direction.Right)
		_flip_hitbox(CharacterState.Direction.Right)
		character.state.change_state(CharacterState.States.RUNNING)
	if character.velocity.x < 0 and character.is_on_floor():
		character.state.change_direction(CharacterState.Direction.Left)
		_flip_hitbox(CharacterState.Direction.Left)
		character.state.change_state(CharacterState.States.RUNNING)
	elif character.velocity.y < 0:
		character.state.change_state(CharacterState.States.JUMPING)
