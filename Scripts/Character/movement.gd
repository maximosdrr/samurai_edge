# PlayerMovement.gd
extends Node

class_name CharacterMovement

var speed
var jump_force
var character: BaseCharacter
var hitbox: CollisionShape2D

var movement_actions = [
	CharacterState.States.IDLE,
	CharacterState.States.RUNNING,
	CharacterState.States.JUMPING,
]

var movimentation_is_blocked = false

func _init(body: BaseCharacter):
	character = body
	hitbox = character.get_node("HitBox").get_node("Area")
	self.speed = character.attributes.speed
	self.jump_force = character.attributes.jump_force
	
func move_x(direction: int):
	if movimentation_is_blocked: return
	if direction:
		character.velocity.x = direction * speed
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)
	_update_state()
	character.move_and_slide()

func jump(delta: float):
	if movimentation_is_blocked: return
	character.velocity.y = jump_force
	_update_state()
	character.move_and_slide()

func add_gravity(delta: float):
	if not character.is_on_floor():
		character.velocity += character.get_gravity()  * delta
		character.move_and_slide()

func stop():
	if movimentation_is_blocked: return
	character.velocity.x = 0
	_update_state()
	character.move_and_slide()

func change_block_movement(value: bool):
	self.movimentation_is_blocked = value

func push_back(force: float):
	var push_direction = -1 if self.character.state.current_direction == CharacterState.Direction.Right else 1
	print(push_direction)
	print(self.character.state.current_direction)
	self.character.velocity.x = force * push_direction
	character.move_and_slide()

func _flip_hitbox(direction: CharacterState.Direction):
	if direction == CharacterState.Direction.Right:
		hitbox.position.x = 23.25
	else:
		hitbox.position.x = -20.25

func _update_state():
	if character.state.current_state not in movement_actions:
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
