# PlayerAttack.gd
extends Node
class_name CharacterParry

var character: CharacterBody2D
var animated_sprite: AnimatedSprite2D

var timer: Timer
var parry_duration = 0.3

func _init(body: CharacterBody2D):
	character = body
	self.animated_sprite = body.get_node("animated_sprite")
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = parry_duration
	self.character.add_child(timer)
	timer.connect("timeout", Callable(self, "_on_parry_ends"))

func parry():
	if character.state.current_state == CharacterState.States.DASHING:
		return
	if character.state.current_state != CharacterState.States.PARRYING:
		character.state.change_state(CharacterState.States.PARRYING)
		character.attack.cancel_attack()
		timer.start()

func _on_parry_ends():
	character.state.change_state(CharacterState.States.IDLE)
