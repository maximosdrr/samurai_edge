# PlayerAnimator.gd
extends Node

class_name CharacterAnimator

var animation_player: AnimatedSprite2D
var character: BaseCharacter

var last_attack_animation = "attack"

func _init(character: BaseCharacter):
	animation_player = character.get_node("animated_sprite")
	character.state.character_state_change.connect(play_animation)
	character.state.character_direction_change.connect(flip_sprite)
	self.character = character

func play_animation(state: CharacterState.States):
	match state:
		CharacterState.States.IDLE:
			animation_player.play("idle")
		CharacterState.States.RUNNING:
			animation_player.play("run")
		CharacterState.States.JUMPING:
			animation_player.play("jump")
		CharacterState.States.ATTACKING:
			animation_player.play("attack_1")
		CharacterState.States.RECEIVING_DAMAGE:
			animation_player.play("receive_damage")
		CharacterState.States.PARRYING:
			animation_player.play("parry")
		CharacterState.States.DASHING:
			animation_player.play("dash")
			
func flip_sprite(direction: CharacterState.Direction):
	animation_player.flip_h = true if direction == CharacterState.Direction.Left else false

func _play_attack_animation():
	var next_attack_animation_map = {
		"attack": "attack_1",
		"attack_1": "attack"
	}
	
	var nextAnimation = next_attack_animation_map[last_attack_animation]
	last_attack_animation = nextAnimation
	
	return nextAnimation
