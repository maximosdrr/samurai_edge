# PlayerMovement.gd
extends Node

class_name CharacterMovement

var speed
var jump_force
var character: CharacterBody2D
var hitbox: CollisionShape2D

func _init(body: CharacterBody2D, speed: int, jump_force: int):
	character = body
	hitbox = character.get_node("HitBox").get_node("Area")
	self.speed = speed
	self.jump_force = jump_force
	
func move_x(direction: int):
	if direction:
		character.velocity.x = direction * speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)
	_update_state()
	character.move_and_slide()

func jump(delta: float):
	character.velocity.y = jump_force
	_update_state()
	character.move_and_slide()

func add_gravity(delta: float):
	if not character.is_on_floor():
		character.velocity += character.get_gravity()  * delta

func stop():
	character.velocity.x = 0
	_update_state()
	character.move_and_slide()

func _flip_hitbox(direction: CharacterState.Direction):
	if direction == CharacterState.Direction.Right:
		hitbox.position.x = 27.0
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
