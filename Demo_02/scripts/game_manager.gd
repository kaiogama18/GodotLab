extends Node

@export var object_templates : Array[PackedScene]

func _input(event):
	# Check if event is a left click
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		spawn_object(event.position)

func spawn_object(position : Vector2):
	if object_templates.size():
		var index: int = randi_range(0, object_templates.size() - 1)
		var object_template: PackedScene = object_templates[index]
		var object: RigidBody2D = object_template.instantiate()
		object.position = position
		add_child(object)
