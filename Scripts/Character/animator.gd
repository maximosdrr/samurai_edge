# PlayerAnimator.gd
extends Node

class_name CharacterAnimator

var animation_player: AnimatedSprite2D
var character: CharacterBody2D

var last_attack_animation = "attack"

func _init(character: CharacterBody2D):
	animation_player = character.get_node("animated_sprite")
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
			var animation = _play_attack_animation()
			animation_player.play(animation)
		CharacterState.States.RECEIVING_DAMAGE:
			animation_player.play("receive_damage")
		CharacterState.States.DEAD:
			animation_player.play("die")
		CharacterState.States.PARRYING:
			animation_player.play("parry")
		CharacterState.States.DASHING:
			animation_player.play("dash")
			
func _flip_sprite(direction: CharacterState.Direction):
	animation_player.flip_h = true if direction == CharacterState.Direction.Left else false

func _play_attack_animation():
	var next_attack_animation_map = {
		"attack": "attack_1",
		"attack_1": "attack"
	}
	
	var nextAnimation = next_attack_animation_map[last_attack_animation]
	last_attack_animation = nextAnimation
	
	return nextAnimation
