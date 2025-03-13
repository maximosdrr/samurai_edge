# PlayerAttack.gd
extends Node
class_name CharacterAttack

var character: CharacterBody2D
var collisionArea: CollisionShape2D

func _init(body: CharacterBody2D):
	character = body
	character.hitbox.connect("body_entered", Callable(self, "_on_hit_detected"))
	character.animated_sprite.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	self.collisionArea = character.hitbox.get_node("Area")

func attack():
	character.state.change_state(CharacterState.States.ATTACKING)
	collisionArea.set_deferred("disabled", false)

func _on_hit_detected(body: Node2D):
	for group in body.get_groups():
		if group == 'enemy':
			body.take_damage()

func _on_attack_animation_finished():
	if character.animated_sprite.animation == "attack":
		character.state.change_state(CharacterState.States.IDLE)
		collisionArea.set_deferred("disabled", true)
