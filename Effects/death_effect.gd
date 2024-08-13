extends AnimatedSprite2D

func run_effect():
	visible = true
	frame = 0
	play("default")

func _on_animation_finished():
	visible = false
