class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int =  10
@export var death_prefab: PackedScene
var damage_digit_prefab: PackedScene

@onready var damage_digit_market = $DamageDigitMarker

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int):
	health -= amount
	
	# Modulate change
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_market:
		damage_digit.global_position = damage_digit_market.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	if randf() <= drop_chance:
		drop_item()	
	queue_free()

func drop_item():
	var drop = get_radom_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_radom_drop_item() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
		
	# Calculate the max chance
	var max_change: float = 0.0
	for drop_chance in drop_chance:
		max_change += drop_chance
	
	#Play a dice
	var random_value = randf() * max_change
	
	#Play the Spin Wheel
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]
