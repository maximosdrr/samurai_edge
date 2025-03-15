extends Node

class_name CharacterReceiveDamage

var character: BaseCharacter
var animated_sprite: AnimatedSprite2D
var timer: Timer
var receive_damage_duration = 0.3

func _init(character: BaseCharacter):
	self.character = character
	self.animated_sprite = character.get_node("animated_sprite")
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = receive_damage_duration
	self.character.add_child(timer)
	timer.connect("timeout", Callable(self, "_on_receive_damage_ends"))
	
func receive(amount):
	character.state.change_state(CharacterState.States.RECEIVING_DAMAGE)
	character.attack.cancel_attack()
	character.movement.push_back(500)
	timer.start()
	character.state.set_state_change_is_blocked(true)
	character.attributes.decreaseHealth(amount)
	
func _on_receive_damage_ends():
	character.state.set_state_change_is_blocked(false)
	character.state.change_state(CharacterState.States.IDLE)
	timer.stop()
