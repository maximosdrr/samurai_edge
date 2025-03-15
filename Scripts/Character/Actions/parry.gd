# PlayerAttack.gd
extends Node
class_name CharacterParry

var character: BaseCharacter
var animated_sprite: AnimatedSprite2D

var timer: Timer
var parry_duration = 0.3

func _init(body: BaseCharacter):
	self.character = body
	self.animated_sprite = body.get_node("animated_sprite")
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = parry_duration
	self.character.add_child(timer)
	self.timer.timeout.connect(_on_parry_ends)
	self.character.attack.attack_parried_detected.connect(_parry_success)

func _parry_success():
	self.character.movement.push_back(400)

func parry():
	if character.state.current_state == CharacterState.States.DASHING:
		return
	if character.state.current_state != CharacterState.States.PARRYING:
		character.state.change_state(CharacterState.States.PARRYING)
		character.attack.cancel_attack()
		timer.start()

func _on_parry_ends():
	character.state.change_state(CharacterState.States.IDLE)
