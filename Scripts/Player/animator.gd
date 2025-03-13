# PlayerAnimator.gd
extends Node

class_name PlayerAnimator

var animation_player: AnimatedSprite2D
var player: CharacterBody2D

func _init(anim_player: AnimatedSprite2D, player: CharacterBody2D):
	animation_player = anim_player
	player.state.connect("player_state_change", Callable(self, "_play_animation"))
	player.state.connect("player_direction_change", Callable(self, "_flip_sprite"))
	self.player = player

func _play_animation(state: PlayerState.States):
	match state:
		PlayerState.States.IDLE:
			animation_player.play("idle")
		PlayerState.States.RUNNING:
			animation_player.play("run")
		PlayerState.States.JUMPING:
			animation_player.play("jump")
		PlayerState.States.ATTACKING:
			animation_player.play("attack")
			
func _flip_sprite(direction: PlayerState.Direction):
	animation_player.flip_h = true if direction == PlayerState.Direction.Left else false
