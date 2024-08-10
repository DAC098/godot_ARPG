extends Camera2D


@onready var player: Player = $"../Player"

@export_category("Smoothing")
@export var smoothing_enabled: bool = false
@export_range(1, 10) var smoothing_distance: int = 8

@export_category("")

var max_zoom: float = 1.25
var min_zoom: float = 0.75
var step_zoom: float = 0.125

var weight: float

func _ready():
	weight = float(11 - smoothing_distance) / 100

func _physics_process(delta):
	if player != null:
		var pos: Vector2

		if smoothing_enabled:
			pos = lerp(global_position, player.global_position, weight)
		else:
			pos = player.global_position

		global_position = pos.floor()

func _process(delta):
	if Input.is_action_just_pressed("zoom_in"):
		zoom_in()
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_out()

func center_on_player():
	global_position = player.global_position

func zoom_in():
	zoom.x = clamp(zoom.x + step_zoom, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y + step_zoom, min_zoom, max_zoom)

func zoom_out():
	zoom.x = clamp(zoom.x - step_zoom, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y - step_zoom, min_zoom, max_zoom)
