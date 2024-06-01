extends CanvasLayer

@onready var timer_label = %TimerLabel
@onready var gold_label = %GoldLabel
@onready var meat_label = %MeatLabel

func _process(delta):
	# Update labels
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = "%2d Meat" % [GameManager.meat_counter]


