extends Node

class_name CharacterReceiveDamage

var character: CharacterBody2D
var animated_sprite: AnimatedSprite2D

func _init(character: CharacterBody2D):
	self.character = character
	self.animated_sprite = character.get_node("animated_sprite")
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

	
func receive(amount):
	character.state.change_state(CharacterState.States.RECEIVING_DAMAGE)
	character.state.set_state_change_is_blocked(true)
	character.attributes.decreaseHealth(amount)
	

func _on_animation_finished():
	if animated_sprite.animation == "receive_damage":
		character.state.set_state_change_is_blocked(false)
		character.state.change_state(CharacterState.States.IDLE)
