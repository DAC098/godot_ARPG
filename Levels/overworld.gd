extends Node2D

@onready var enemies_container = $enemies

var total_enemies: int = 0

signal enemies_changed(count: int)

func _ready():
	print("overworld ready")
	
	var children = enemies_container.get_children()
	
	total_enemies = children.size()
	
	for child in enemies_container.get_children():
		child.killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy: Bat):
	total_enemies -= 1

	print("enemy killed. remaining: ", total_enemies, " ", enemy.get_rid())
	
	emit_signal("enemies_changed", total_enemies)
