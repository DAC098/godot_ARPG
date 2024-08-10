extends CharacterBody2D

class_name Player

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

@export_category("Movement")
@export var acceleration: int = 400
@export var friction: int = 400
@export var max_speed: int = 100
@export var roll_speed: int = 150

@export_category("God")
var invincible: bool = false

@export_category("")

enum {
	Move,
	Roll,
	Attack,
}

var state = Move

var roll_vector = Vector2.LEFT

@onready var stats = $Stats

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hit_box = $SwordPivot/SwordHitBox
@onready var hurt_box = $HurtBox
@onready var hit_effect = $HitEffect

func _ready():
	print("Player script ready")
	
	animation_tree.active = true
	
	sword_hit_box.knockback_vector = roll_vector
	
	update_anim_tree_blend(roll_vector)

func _process(delta):
	match state:
		Move: move_state(delta)
		Attack: attack_state(delta)
		Roll: roll_state(delta)

func attack_state(_delta):
	velocity = Vector2.ZERO
	
	animation_state.travel("attack")
	
func attack_animation_finished():
	state = Move

func roll_state(_delta):
	animation_state.travel("roll")
	hurt_box.monitoring = false;
	
	velocity = roll_vector * roll_speed
	
	move_and_slide()

func roll_animation_finished():
	if get_input_vector() == Vector2.ZERO:
		velocity = roll_vector * 0.8
	
	hurt_box.monitoring = true;
	
	state = Move

func update_anim_tree_blend(vector):
	animation_tree.set("parameters/idle/blend_position", vector)
	animation_tree.set("parameters/run/blend_position", vector)
	animation_tree.set("parameters/attack/blend_position", vector)
	animation_tree.set("parameters/roll/blend_position", vector)
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return input_vector.normalized()

func move_state(delta):
	var input_vector = get_input_vector()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hit_box.knockback_vector = input_vector

		update_anim_tree_blend(input_vector)

		animation_state.travel("run")

		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animation_state.travel("idle")

		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		state = Attack
	elif Input.is_action_just_pressed("roll"):
		state = Roll

func _on_hurt_box_area_entered(area):
	if invincible:
		pass

	if !stats.apply_damage(area):
		print("player dead")
	else:
		print("player hit for ", area)

		hit_effect.run_effect()
