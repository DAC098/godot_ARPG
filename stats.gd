extends Node

class_name Stats

@export_category("Health")
@export var max_health: int = 1
@export var health: int = 1

signal no_health
signal health_change

func apply_damage(damage: HitBox):
	if health > 0:
		if damage.physical > health:
			health = 0
		else:
			health -= damage.physical

		emit_signal("health_change", health)
	else:
		emit_signal("no_health")

	return health > 0

func apply_healing(heal: int):
	health = (health + heal) % max_health
	
	emit_signal("health_change", health)
