extends Node

class_name CharacterDie

var character: BaseCharacter
var animated_sprite: AnimatedSprite2D

func _init(character: BaseCharacter):
	self.character = character
	self.animated_sprite = character.get_node("animated_sprite")
	self.character.attributes.character_die.connect(execute)
	
func execute():
	character.state.set_state_change_is_blocked(false)
	character.state.change_state(CharacterState.States.DEAD)
	animated_sprite.play("die")
	character.get_node("HurtBox").set_deferred("disabled", true)
	character.get_node("HitBox").set_deferred("disabled", true)
	character.set_process(false)
	character.set_physics_process(false)
	character.set_process_input(false)
	character.set_process_unhandled_input(false)
