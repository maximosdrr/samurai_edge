# PlayerAnimator.gd
extends Node

class_name CharacterAnimator

var animation_player: AnimatedSprite2D
var character: CharacterBody2D

func _init(anim_player: AnimatedSprite2D, character: CharacterBody2D):
	animation_player = anim_player
	character.state.connect("character_state_change", Callable(self, "_play_animation"))
	character.state.connect("character_direction_change", Callable(self, "_flip_sprite"))
	self.character = character

func _play_animation(state: CharacterState.States):
	match state:
		CharacterState.States.IDLE:
			animation_player.play("idle")
		CharacterState.States.RUNNING:
			animation_player.play("run")
		CharacterState.States.JUMPING:
			animation_player.play("jump")
		CharacterState.States.ATTACKING:
			animation_player.play("attack")
			
func _flip_sprite(direction: CharacterState.Direction):
	animation_player.flip_h = true if direction == CharacterState.Direction.Left else false
