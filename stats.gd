extends Node

@export_category("Health")
@export var max_health: int = 1
@export var health: int = 1

signal no_health
signal health_change

func apply_damage(damage: HitBox):
	if health > 0:
		health -= damage.physical

		emit_signal("no_health")
	else:
		emit_signal("health_change", health)

	return health > 0

func apply_healing(heal: int):
	health = (health + heal) % max_health
	
	emit_signal("health_change", health)
