extends Node2D

@onready var alive = $alive
@onready var death_anim = $death_anim

func _on_hurt_box_area_entered(_area):
	alive.visible = false
	
	death_anim.visible = true
	death_anim.play("default")

func _on_death_anim_animation_finished():
	queue_free()
