extends Node

@export var max_health: int = 1
@export var health: int = 1

signal no_health

func apply_damage(damage: int):
	if health > 0:
		health -= damage
		
		emit_signal("no_health")
	
	return health > 0

func apply_healing(heal: int):
	health = (health + heal) % max_health
