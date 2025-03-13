# PlayerMovement.gd
extends Node

class_name PlayerMovement

var speed = 200
var jump_force = -400
var player: CharacterBody2D
var hitbox: CollisionShape2D

func _init(body: CharacterBody2D):
	player = body
	hitbox = player.get_node("HitBox").get_node("Area")

func process_movement(delta):
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		player.velocity.x = direction * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_force
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity()  * delta
		
	_update_state()
	player.move_and_slide()

func _update_state():
	if player.state.current_state == PlayerState.States.ATTACKING:
		return
	if player.velocity.x == 0 and player.is_on_floor():
		player.state.change_state(PlayerState.States.IDLE)
	if player.velocity.x > 0 and player.is_on_floor():
		player.state.change_direction(PlayerState.Direction.Right)
		hitbox.position.x = 25.5
		player.state.change_state(PlayerState.States.RUNNING)
	if player.velocity.x < 0 and player.is_on_floor():
		player.state.change_direction(PlayerState.Direction.Left)
		hitbox.position.x = -23.5
		player.state.change_state(PlayerState.States.RUNNING)
	elif player.velocity.y < 0:
		player.state.change_state(PlayerState.States.JUMPING)
