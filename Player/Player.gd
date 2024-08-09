extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

@export_category("Movement")
@export var acceleration = 400
@export var friction = 400
@export var max_speed = 100
@export var roll_speed = 150

@export_category("")

enum {
	Move,
	Roll,
	Attack,
}

var state = Move

var roll_vector = Vector2.LEFT

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hit_box = $SwordPivot/SwordHitBox

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
	animation_state.travel("attack")
	
func attack_animation_finished():
	state = Move

func roll_state(_delta):
	animation_state.travel("roll")
	
	velocity = roll_vector * roll_speed
	
	move_and_slide()

func roll_animation_finished():
	if get_input_vector() == Vector2.ZERO:
		velocity = roll_vector * 0.8
	
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

	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
