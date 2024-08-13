extends Control

class_name HeartIndicator

@onready var empty: TextureRect = $empty
@onready var full: TextureRect = $full

enum HeartState {
	Empty,
	Half,
	Full,
}

var potential = HeartState.Full
var current = HeartState.Empty

func _ready():
	update_potential()
	update_current()

func set_potential(state: HeartState):
	if state == potential:
		return

	potential = state

	if empty != null:
		update_potential()

func set_current(state: HeartState):
	if state > potential || state == current:
		return

	current = state

	if full != null:
		update_current()

func update_potential():
	match potential:
		HeartState.Empty:
			empty.size.x = 0
		HeartState.Half:
			empty.size.x = 7
		HeartState.Full:
			empty.size.x = 15

func update_current():
	match current:
		HeartState.Empty:
			full.size.x = 0
		HeartState.Half:
			full.size.x = 7
		HeartState.Full:
			full.size.x = 15
