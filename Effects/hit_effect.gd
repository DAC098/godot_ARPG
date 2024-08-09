extends AnimatedSprite2D

func run_effect():
	visible = true
	play("default")

func _on_animation_finished():
	visible = false
