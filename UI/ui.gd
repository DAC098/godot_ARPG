extends Control

const heart_indicator = preload("res://UI/heart_indicator.tscn")

@export var hearts_vert_padding: int = 2
@export var hearts_horz_padding: int = 2
@export var hearts_per_line: int = 10

@onready var hearts_container = $hearts
@onready var enemy_counter: EnemyCounter = $Counters/EnemyCounter

var current_max_health: int = 0
var current_health: int = 0
var current_health_index: int = 0
var current_indicators: Array[HeartIndicator] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ui ready")

	pass # Replace with function body.

func add_heart(initial: HeartIndicator.HeartState):
	var size = current_indicators.size()
	var row = size / hearts_per_line
	var col = size % hearts_per_line
	
	var indicator: HeartIndicator = heart_indicator.instantiate()
	indicator.position.y = (15 + hearts_vert_padding) * row
	indicator.position.x = (11 + hearts_horz_padding) * col
	indicator.set_potential(initial)

	hearts_container.add_child(indicator)
	current_indicators.push_back(indicator)

func set_max_health(value: int):
	if value < 0:
		printerr("cannot set hearts to a negative value")
		pass

	var modded: int
	var last: HeartIndicator.HeartState

	if value % 2 == 0:
		modded = value / 2
		last = HeartIndicator.HeartState.Full
	else:
		modded = (value / 2) + 1
		last = HeartIndicator.HeartState.Half

	if value < current_max_health:
		# remove indicators
		for index in range(modded, current_indicators.size()):
			current_indicators[index].set_potential(HeartIndicator.HeartState.Empty)
		
		current_indicators[modded - 1].set_potential(last)
	elif value > current_max_health:
		# add indicators
		var size_diff = modded - current_indicators.size()

		if size_diff > 0:
			for index in range(current_max_health / 2, current_indicators.size()):
				current_indicators[index].set_potential(HeartIndicator.HeartState.Full)

			for count in range(size_diff - 1):
				add_heart(HeartIndicator.HeartState.Full)

			add_heart(last)
		else:
			for index in range(modded, current_indicators.size() - 1):
				current_indicators[index].set_potential(HeartIndicator.HeartState.Full)

			current_indicators[current_indicators.size() - 1].set_potential(last)

	current_max_health = value

	if current_max_health < current_health:
		set_health(current_max_health)

func set_health(value: int):
	if value < 0 || value > current_max_health:
		printerr("invalid health value provided. must be between 0 and ", current_max_health)
		pass

	if value == 0:
		for index in range(0, current_health_index + 1):
			current_indicators[index].set_current(HeartIndicator.HeartState.Empty)

		current_health = 0
		current_health_index = 0

		return

	var modded: int
	var last: HeartIndicator.HeartState

	if value % 2 == 0:
		modded = (value / 2) - 1
		last = HeartIndicator.HeartState.Full
	else:
		modded = value / 2
		last = HeartIndicator.HeartState.Half

	if value < current_health:
		# set health indicators to lower
		for index in range(modded + 1, current_health_index + 1):
			current_indicators[index].set_current(HeartIndicator.HeartState.Empty)

		current_indicators[modded].set_current(last)
	elif value > current_health:
		# set health indicators to higher
		for index in range(current_health_index, modded):
			current_indicators[index].set_current(HeartIndicator.HeartState.Full)

		current_indicators[modded].set_current(last)

	current_health = value
	current_health_index = modded

func set_enemy_count(count: int):
	enemy_counter.update_count(count)
