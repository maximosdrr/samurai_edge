extends Node
class_name CharacterAttack

var character: BaseCharacter
var collisionArea: CollisionShape2D
var hitbox: Area2D
var timer: Timer
var attack_duration = 0.3

var characters_in_attack_area: Array[Node2D] = []
signal attack_parried_detected

func _init(body: BaseCharacter):
	character = body
	hitbox = body.get_node("HitBox");
	hitbox.body_entered.connect(_on_hit_detected)
	#hitbox.body_exited.connect(_on_body_outs_hitbox)
	self.collisionArea = hitbox.get_node("Area")
	#timer
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = attack_duration
	self.character.add_child(timer)
	self.timer.timeout.connect(_commit_attack)
	
func attack():
	if character.state.current_state == CharacterState.States.RECEIVING_DAMAGE:
		return
	if character.state.current_state == CharacterState.States.ATTACKING:
		return
	if character.state.current_state == CharacterState.States.PARRYING:
		return
	if character.state.current_state == CharacterState.States.DASHING:
		return
	character.state.change_state(CharacterState.States.ATTACKING)
	collisionArea.set_deferred("disabled", false)
	timer.start()

func cancel_attack():
	collisionArea.set_deferred("disabled", true)

func _commit_attack():
	if characters_in_attack_area.is_empty():
		character.audio_player.play("sword_wipe")
	for chr in characters_in_attack_area:
		if chr.state.current_state != CharacterState.States.PARRYING:
			chr.receive_damage.receive(character.attributes.attack_damage)
			character.audio_player.play("sword_hit")
		else:
			chr.attack.attack_parried_detected.emit()
	characters_in_attack_area.clear()
	collisionArea.set_deferred("disabled", true)
	character.state.change_state(CharacterState.States.IDLE)
	
func _on_hit_detected(body: Node2D):
	if body == character:
		return
	for group in body.get_groups():
		if group == 'character':
			characters_in_attack_area.append(body)

#func _on_body_outs_hitbox(body: Node2D):
#	var aux = characters_in_attack_area
#	characters_in_attack_area.clear()
#	for character in aux:
#		if body.get_instance_id() != character.get_instance_id():
#			characters_in_attack_area.append(character)
