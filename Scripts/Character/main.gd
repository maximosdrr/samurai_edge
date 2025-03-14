# Player.gd
extends CharacterBody2D

class_name Character

var state: CharacterState
var animator: CharacterAnimator
var movement: CharacterMovement
var attack: CharacterAttack
var receive_damage: CharacterReceiveDamage

var jump_force = -400
var speed = 200

func _ready():
	state = CharacterState.new()
	animator = CharacterAnimator.new(self)
	movement = CharacterMovement.new(self, speed, jump_force)
	receive_damage = CharacterReceiveDamage.new(self)
	attack = CharacterAttack.new(self)
	
