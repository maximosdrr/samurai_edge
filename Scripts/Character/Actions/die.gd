extends Node

class_name CharacterDie

var character: CharacterBody2D
var animated_sprite: AnimatedSprite2D

signal character_died

func _init(character: CharacterBody2D):
	self.character = character
	self.animated_sprite = character.get_node("animated_sprite")
	
func execute():
	character.state.set_state_change_is_blocked(false)
	character.state.change_state(CharacterState.States.DEAD)
	character.get_node("HurtBox").set_deferred("disabled", true)
	character.get_node("HitBox").set_deferred("disabled", true)
	character.set_process(false)
	character.set_physics_process(false)
	character.set_process_input(false)
	character.set_process_unhandled_input(false)
	character_died.emit()
