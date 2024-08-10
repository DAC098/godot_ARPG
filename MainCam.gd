extends Camera2D

@onready var player = $"../Player"

func center_on_player():
	global_position = player.global_position

func _process(delta):
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x = clamp(zoom.x + 0.1, 0.9, 1.5)
		zoom.y = clamp(zoom.y + 0.1, 0.9, 1.5)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom.x = clamp(zoom.x - 0.1, 0.9, 1.5)
		zoom.y = clamp(zoom.y - 0.1, 0.9, 1.5)
