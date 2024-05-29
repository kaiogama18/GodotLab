extends CharacterBody2D

@export var speed = 3
@export_range(0, 1) var lerp_factor = 0.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprete_2d: Sprite2D = $Sprite2D

var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0

func _process(delta):
	# update attack cool down
	if is_attacking:
		attack_cooldown -= delta # 0.6 = 0.016  --> 0.584
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func _physics_process(delta):
	# Get the input vector
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	# Remove Control DeadZone 
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	
	# Modify the speed
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity  *= 0.25
	velocity = lerp(velocity, target_velocity, lerp_factor)
	move_and_slide()
	
	# Check is Running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
		
	# Play the animation
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	
	# Flip Sprite 
	if input_vector.x > 0:
		$Sprite2D.flip_h = false
	elif input_vector.x < 0:
		$Sprite2D.flip_h = true
		
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack()
	
func attack():
	if is_attacking:
		return
	
	# attack_side 1
	# attack_side 2
	
	# Play attack anim
	is_attacking = true
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
