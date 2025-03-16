extends Node


class_name CharacterDash

var character: BaseCharacter
var timer: Timer
var dash_duration = 0.4
var dash_units = 100

func _init(char: BaseCharacter):
	self.character = char
	#timer
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = dash_duration
	self.character.add_child(timer)
	self.timer.timeout.connect(dash_ends)
	
func dash():
	if character.state.current_state == CharacterState.States.DASHING:
		return
	if character.state.current_state == CharacterState.States.RECEIVING_DAMAGE:
		return
	if character.state.current_state == CharacterState.States.ATTACKING:
		return
	if character.state.current_state == CharacterState.States.PARRYING:
		return
	timer.start()
	character.state.change_state(CharacterState.States.DASHING)
	character.audio_player.play("dash")
	character.movement.change_block_movement(true)
	
func dash_ends():
	await _move()
	character.state.change_state(CharacterState.States.RUNNING)
	character.movement.change_block_movement(false)
	
func _move():
	var direction = _get_parsed_direction()
	var result = direction * dash_units
	
	character.position.x += result

func _get_parsed_direction():
	return 1 if character.state.current_direction == CharacterState.Direction.Right else -1
	
