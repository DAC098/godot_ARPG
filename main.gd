extends Node2D

@onready var ui = $CanvasLayer/Ui
@onready var player = $Player

var test_index = 0
var test_list = [5, 4, 6, 10, 7]

# Called when the node enters the scene tree for the first time.
func _ready():
	print("main ready")
	
	player.stats.health_change.connect(_on_player_stats_health_change)
	
	ui.set_max_health(player.stats.max_health)
	ui.set_health(player.stats.health)

func _on_player_stats_health_change(amount):
	ui.set_health(amount)
	
	if amount == 0:
		player.disable_hurtbox(true)
