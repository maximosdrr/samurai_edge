# PlayerState.gd
extends Node

class_name CharacterState

enum States { IDLE, RUNNING, JUMPING, ATTACKING, RECEIVING_DAMAGE }
enum Direction { Left, Right }

var current_state = States.IDLE
var current_direction = Direction.Right

signal character_state_change
signal character_direction_change

func change_state(new_state):
	if new_state == States.RUNNING and current_state == States.RUNNING:
		return
	elif new_state == States.IDLE and current_state == States.IDLE:
		return
	elif new_state == States.JUMPING and current_state == States.JUMPING:
		return
	else:
		current_state = new_state
		self.character_state_change.emit(self.current_state)

func change_direction(direction):
	current_direction = direction
	character_direction_change.emit(direction)
