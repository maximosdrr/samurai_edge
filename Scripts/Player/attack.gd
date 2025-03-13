# PlayerAttack.gd
extends Node
class_name PlayerAttack

var player: CharacterBody2D
var collisionArea: CollisionShape2D

func _init(player_body: CharacterBody2D):
	player = player_body
	player.hitbox.connect("body_entered", Callable(self, "_on_hit_detected"))
	player.animated_sprite.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	self.collisionArea = player.hitbox.get_node("Area")

func attack():
	player.state.change_state(PlayerState.States.ATTACKING)
	collisionArea.set_deferred("disabled", false)

func _on_hit_detected(body: Node2D):
	for group in body.get_groups():
		if group == 'enemy':
			body.take_damage()

func _on_attack_animation_finished():
	if player.animated_sprite.animation == "attack":
		player.state.change_state(PlayerState.States.IDLE)
		collisionArea.set_deferred("disabled", true)
