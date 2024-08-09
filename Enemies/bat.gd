extends CharacterBody2D

@onready var alive_anim = $alive_anim
@onready var death_anim = $death_anim
@onready var hurt_box_collider = $HurtBox/CollisionShape2D
@onready var hit_effect = $HitEffect

@onready var stats = $Stats

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)

	move_and_slide()

func _on_hurt_box_area_entered(area):
	velocity = area.knockback_vector * 150

	if !stats.apply_damage(area.damage):
		hurt_box_collider.set_deferred("disabled", true)
		
		alive_anim.stop()
		alive_anim.visible = false
		
		death_anim.visible = true
		death_anim.play("default")
	else:
		hit_effect.run_effect()

func _on_death_anim_animation_finished():
	queue_free()
