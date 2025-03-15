extends Node

class_name SfxManager

var character: BaseCharacter
var sfx_node: Node

#sounds
var parry: AudioStreamPlayer2D
var sword_wipe: AudioStreamPlayer2D
var sword_hit: AudioStreamPlayer2D

func _init(character: BaseCharacter):
	self.character = character
	self.sfx_node = character.get_node("SoundEffects")
	#sounds
	self.parry = sfx_node.get_node("Parry")
	self.sword_wipe = sfx_node.get_node("Wipe")
	self.sword_hit = sfx_node.get_node("SwordHit")
	

func play(sfx_name: String):
	var sound = self.get(sfx_name) as AudioStreamPlayer2D
	sound.play()

func stop(sfx_name: String):
	var sound = self.get(sfx_name) as AudioStreamPlayer2D
	sound.stop()
	
