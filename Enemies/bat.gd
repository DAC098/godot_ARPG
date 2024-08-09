extends CharacterBody2D

@export_category("Movement")
@export var acceleration = 200
@export var friction = 400
@export var max_speed = 80

@export_category("")

enum {
	Idle,
	Wander,
	Chase,
}

var state = Idle

@onready var stats = $Stats

@onready var alive_anim = $alive_anim
@onready var death_anim = $death_anim
@onready var hit_box_collider = $HurtBox/CollisionShape2D
@onready var hurt_box_collider = $HurtBox/CollisionShape2D
@onready var hit_effect = $HitEffect
@onready var detection = $PlayerDetection

func _physics_process(delta):
	match state:
		Idle:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		Wander: pass
		Chase:
			var direction = (detection.player.global_position - global_position).normalized()

			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

	alive_anim.flip_h = velocity.x < 0

	move_and_slide()

func seek_player():
	pass

func _on_hurt_box_area_entered(area):
	velocity = area.knockback_vector * 150

	if !stats.apply_damage(area):
		state = Idle
		
		hit_box_collider.set_deferred("disabled", true)
		hurt_box_collider.set_deferred("disabled", true)
		
		alive_anim.stop()
		alive_anim.visible = false
		
		death_anim.visible = true
		death_anim.play("default")
	else:
		hit_effect.run_effect()

func _on_death_anim_animation_finished():
	queue_free()

func _on_player_detection_found():
	state = Chase

func _on_player_detection_lost():
	state = Idle
