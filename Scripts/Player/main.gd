# Player.gd
extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox # A área de ataque

var state: PlayerState
var animator: PlayerAnimator
var movement: PlayerMovement
var attack: PlayerAttack

func _ready():
	state = PlayerState.new()
	animator = PlayerAnimator.new(animated_sprite, self)
	movement = PlayerMovement.new(self)
	attack = PlayerAttack.new(self)
	
func _physics_process(delta: float) -> void:
	movement.process_movement(delta)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack.attack()
