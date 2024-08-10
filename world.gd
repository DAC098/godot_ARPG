extends Node2D

@onready var main_cam = $MainCam

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Overworld ready")
	
	main_cam.center_on_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
