# Player.gd
extends CharacterBody2D

class_name Character

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox

var state: CharacterState
var animator: CharacterAnimator
var movement: CharacterMovement
var attack: CharacterAttack

var jump_force = -400
var speed = 200

func _ready():
	state = CharacterState.new()
	animator = CharacterAnimator.new(animated_sprite, self)
	movement = CharacterMovement.new(self, speed, jump_force)
	attack = CharacterAttack.new(self)
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	movement.add_gravity(delta);
	movement.move_x(direction)
	
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		movement.jump(delta)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
