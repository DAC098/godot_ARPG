extends Area2D

var player = null

signal found
signal lost

func _on_body_entered(body):
	if player == null:
		player = body
		
		emit_signal("found")


func _on_body_exited(body):
	if player == body:
		player = null
		
		emit_signal("lost")
