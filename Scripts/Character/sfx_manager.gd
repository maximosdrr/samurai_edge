extends Node

class_name SfxManager

var character: BaseCharacter
var sfx_node: Node

#sounds
var parry: AudioStreamPlayer2D

func _init(character: BaseCharacter):
	self.character = character
	self.sfx_node = character.get_node("SoundEffects")
	#sounds
	self.parry = sfx_node.get_node("Parry")

func play(sfx_name: String):
	var sound = self.get(sfx_name) as AudioStreamPlayer2D
	sound.play()

func stop(sfx_name: String):
	var sound = self.get(sfx_name) as AudioStreamPlayer2D
	sound.stop()
	
