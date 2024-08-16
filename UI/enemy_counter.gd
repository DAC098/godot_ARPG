class_name EnemyCounter extends PanelContainer

@onready var counter_text = $HFlowContainer/RichTextLabel

var count: int = 0

func _ready():
	counter_text.text = str(count)

func update_count(given: int):
	count = given
	
	if counter_text != null:
		counter_text.text = str(count)
