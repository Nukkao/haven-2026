extends CharacterBody2D


const SPEED = 150.0
const AIRSPEED = 15
const MAXSPEED = 200
const JUMP_VELOCITY = -200

@onready var animated_sprite = $AnimatedSprite2D
@onready var air_move_timer = $AirMoveTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		air_move_timer.start()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#this is FLOOR ONLY MOVEMENT
	#direction will be taken regardless
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if direction:
			velocity.x = direction * SPEED
			#play running animation
			animated_sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			#play idle animation
			animated_sprite.play("idle")
	else:
		if air_move_timer.is_stopped():
			animated_sprite.play("air-idle")
	
	#flipping sprites for direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#AIR MOVEMENT
	if not air_move_timer.is_stopped():
		animated_sprite.play("flip")
		velocity.x += direction * AIRSPEED
	
	#Limit speed
	if abs(velocity.x) > MAXSPEED:
		if velocity.x > 0:
			velocity.x = MAXSPEED
		else:
			velocity.x = -MAXSPEED
	
	
	move_and_slide()
