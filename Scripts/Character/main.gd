# Player.gd
extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox # A área de ataque

var state: CharacterState
var animator: CharacterAnimator
var movement: CharacterMovement
var attack: CharacterAttack

func _ready():
	state = CharacterState.new()
	animator = CharacterAnimator.new(animated_sprite, self)
	movement = CharacterMovement.new(self)
	attack = CharacterAttack.new(self)
	
func _physics_process(delta: float) -> void:
	movement.process_movement(delta)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
