# PlayerAttack.gd
extends Node
class_name CharacterAttack

var character: CharacterBody2D
var collisionArea: CollisionShape2D
var hitbox: Area2D
var animated_sprite: AnimatedSprite2D

func _init(body: CharacterBody2D):
	character = body
	hitbox = body.get_node("HitBox");
	animated_sprite = body.get_node("animated_sprite")
	hitbox.connect("body_entered", Callable(self, "_on_hit_detected"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	self.collisionArea = hitbox.get_node("Area")

func attack():
	character.state.change_state(CharacterState.States.ATTACKING)
	collisionArea.set_deferred("disabled", false)

func _on_hit_detected(body: Node2D):
	for group in body.get_groups():
		if group == 'character':
			body.receive_damage.receive()

func _on_attack_animation_finished():
	if animated_sprite.animation == "attack":
		character.state.change_state(CharacterState.States.IDLE)
		collisionArea.set_deferred("disabled", true)
