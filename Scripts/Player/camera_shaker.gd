extends Node

class_name PlayerCameraShaker

var is_shaking = false
var character: CharacterBody2D
var camera: Camera2D

func _init(character: CharacterBody2D, camera: Camera2D):
	self.character = character
	self.camera = camera
	character.state.connect("character_state_change", Callable(self, "_handle_take_damage"))

func _ready():
	character.attack.connect("attack_parried_detected", Callable(self, "handle_parry_attack"))

func _handle_take_damage(new_state):
	if new_state == CharacterState.States.RECEIVING_DAMAGE and !is_shaking:
		_shake_lvl2()
	elif new_state != CharacterState.States.RECEIVING_DAMAGE and is_shaking:
		_reset_camera()

func _reset_camera():
	is_shaking = false
	var tween = character.get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _shake(level: int, duration: float, intensity: float):
	if is_shaking:
		return
	
	is_shaking = true
	var elapsed_time = 0.0
	
	while character.state.current_state == CharacterState.States.RECEIVING_DAMAGE and elapsed_time < duration:
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		var tween = character.get_tree().create_tween()
		tween.tween_property(camera, "offset", random_offset, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		await character.get_tree().create_timer(0.05).timeout
		elapsed_time += 0.05
	
	_reset_camera()

func _shake_lvl1():
	_shake(1, 0.4, 2.0)

func _shake_lvl2():
	_shake(2, 0.4, 5.0)

func _shake_lvl3():
	_shake(3, 1.0, 10.0)
