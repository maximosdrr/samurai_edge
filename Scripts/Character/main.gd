# Player.gd
extends CharacterBody2D

class_name BaseCharacter

#core
var state: CharacterState
var animator: CharacterAnimator
var movement: CharacterMovement
var attributes: CharacterAttributes

#att
var _jump_force
var _speed
var _attack_damage
var _health

#Actions
var attack: CharacterAttack
var receive_damage: CharacterReceiveDamage
var die: CharacterDie
var parry: CharacterParry
var dash: CharacterDash
var audio_player: SfxManager

func _init(jump_force, speed, attack_damage, health):
	self._jump_force = jump_force
	self._speed = speed
	self._attack_damage = attack_damage
	self._health = health

func _ready():
	#core
	state = CharacterState.new(self)
	animator = CharacterAnimator.new(self)
	attributes = CharacterAttributes.new(self, _speed, _jump_force, _attack_damage, _health)
	movement = CharacterMovement.new(self)
	audio_player = SfxManager.new(self)
	
	#actions
	receive_damage = CharacterReceiveDamage.new(self)
	attack = CharacterAttack.new(self)
	die = CharacterDie.new(self)
	parry = CharacterParry.new(self)
	dash = CharacterDash.new(self)
	
	add_child(state)
	add_child(animator)
	add_child(attributes)
	add_child(movement)
	add_child(audio_player)
	add_child(receive_damage)
	add_child(attack)
	add_child(die)
	add_child(parry)
	add_child(dash)
