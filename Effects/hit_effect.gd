extends AnimatedSprite2D

@export var enable_sound: bool = true

@onready var audio_player: AudioStreamPlayer2D = $HitSound

func run_effect():
	visible = true
	frame = 0
	play("default")
	
	if enable_sound:
		audio_player.play()

func _on_animation_finished():
	visible = false
