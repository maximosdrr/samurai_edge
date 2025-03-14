# PlayerAttack.gd
extends Node
class_name CharacterAttack

var character: CharacterBody2D
var collisionArea: CollisionShape2D
var hitbox: Area2D
var animated_sprite: AnimatedSprite2D
var attack_duration_timmer: Timer
var attack_duration = 0.5

func _init(body: CharacterBody2D):
	character = body
	hitbox = body.get_node("HitBox");
	animated_sprite = body.get_node("animated_sprite")
	hitbox.connect("body_entered", Callable(self, "_on_hit_detected"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))
	self.collisionArea = hitbox.get_node("Area")
	self.attack_duration_timmer = Timer.new()
	attack_duration_timmer.connect("timeout", Callable(self, "_on_attack_ends"))

func attack():
	if character.state.current_state == CharacterState.States.ATTACKING:
		return
	character.state.change_state(CharacterState.States.ATTACKING)
	collisionArea.set_deferred("disabled", false)
	attack_duration_timmer.wait_time = attack_duration
	character.add_child(attack_duration_timmer)
	attack_duration_timmer.start()

func _on_hit_detected(body: Node2D):
	if body == character:
		return
	for group in body.get_groups():
		if group == 'character':
			body.receive_damage.receive(character.attributes.attack_damage)

func _on_attack_animation_finished():
	if animated_sprite.animation == "attack":
		character.state.change_state(CharacterState.States.IDLE)

func _on_attack_ends():
	collisionArea.set_deferred("disabled", true)
