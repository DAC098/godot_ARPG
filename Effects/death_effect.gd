extends AnimatedSprite2D

@export var enable_sound: bool = true

@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func run_effect():
	visible = true
	frame = 0
	play("default")
	
	if enable_sound:
		death_sound.play()

func _on_animation_finished():
	visible = false
