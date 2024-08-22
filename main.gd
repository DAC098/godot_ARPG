extends Node2D

@onready var ui := $CanvasLayer/Ui
@onready var player := $Player
@onready var overworld := $OverWorld

var game_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("main ready")

	player.stats.health_change.connect(_on_player_stats_health_change)

	ui.set_max_health(player.stats.max_health)
	ui.set_health(player.stats.health)
	ui.set_enemy_count(overworld.total_enemies)

func quit_game() -> void:
	get_tree().quit()

func pause_game() -> void:
	game_paused = true

	get_tree().paused = true

	ui.display_menu(true)

func resume_game() -> void:
	game_paused = false

	get_tree().paused = false

	ui.display_menu(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if game_paused:
			resume_game()
		else:
			pause_game()

func _on_player_stats_health_change(amount: int) -> void:
	ui.set_health(amount)

	if amount == 0:
		player.disable_hurtbox(true)

func _on_over_world_enemies_changed(count: int) -> void:
	ui.set_enemy_count(count)

func _on_ui_resume_pressed():
	resume_game()

func _on_ui_exit_pressed():
	quit_game()
