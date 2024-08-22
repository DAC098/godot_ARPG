extends Node2D

enum State {
	Playing,
	Paused,
	Death,
	Won,
}

@onready var ui := $CanvasLayer/Ui
@onready var player := $Player
@onready var overworld := $OverWorld

var state: State = State.Playing

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
	get_tree().paused = true

	ui.display_menu(Ui.MenuType.Pause)

func resume_game() -> void:
	ui.hide_menu()

	get_tree().paused = false

func restart_game() -> void:
	ui.hide_menu()

	get_tree().paused = false
	get_tree().reload_current_scene()

func won_game() -> void:
	ui.display_menu(Ui.MenuType.Won)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		match state:
			State.Paused:
				state = State.Playing

				resume_game()
			State.Playing:
				state = State.Paused
				
				pause_game()

func _on_player_stats_health_change(amount: int) -> void:
	ui.set_health(amount)

	if amount == 0:
		state = State.Death

		player.disable_hurtbox(true)

		ui.display_menu(Ui.MenuType.Death)

func _on_over_world_enemies_changed(count: int) -> void:
	ui.set_enemy_count(count)
	
	if count == 0:
		state = State.Won

		won_game()

func _on_ui_resume_pressed():
	state = State.Playing

	resume_game()

func _on_ui_exit_pressed():
	quit_game()

func _on_ui_restart_pressed():
	restart_game()
