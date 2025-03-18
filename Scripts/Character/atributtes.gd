extends Node

class_name CharacterAttributes

var attack_damage: float
var health: float
var jump_force: float
var speed: float
var character: BaseCharacter

signal character_die
signal health_decrease

func _init(character, speed, jump_force, attack_damage, health):
	self.attack_damage = attack_damage
	self.health = health
	self.speed = speed
	self.jump_force = jump_force
	self.character = character

func decreaseHealth(amount: float):
	self.health -= amount
	print("Character ", character.name, " health: ", self.health)
	self.health_decrease.emit(amount)
	
	if(self.health <= 0):
		character_die.emit()
