extends CharacterBody2D


const SPEED = 150.0
const AIRSPEED = 5
const MAXSPEED = 200
const JUMP_VELOCITY = -200
const DASH_SPEED = 250

var dash_ready = true
var dashing = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var air_move_timer = $AirMoveTimer
@onready var dash_timer = $DashTimer

#death on spike
func _on_spike_body_entered(body: Node2D) -> void:
	position = Vector2(1,1)
	$death.play()

#jump when touch orb
func _on_area_2d_body_entered(body: Node2D) -> void:
	velocity.y = -300
	air_move_timer.start()
	dash_timer.stop()
	dash_ready = true
	$hitOrb.play()

func _physics_process(delta: float) -> void:
	#end the dash
	if dash_timer.is_stopped():
		dashing = false

	# Add the gravity.
	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta
 
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		air_move_timer.start()
		$jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#this is FLOOR ONLY MOVEMENT
	#direction will be taken regardless
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		dash_ready = true
		if direction:
			velocity.x = direction * SPEED
			#play running animation
			animated_sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			#play idle animation
			animated_sprite.play("idle")
	else:
		if air_move_timer.is_stopped() and not dashing:
			animated_sprite.play("air-idle")
	
	#flipping sprites for direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#AIR MOVEMENT
	if not air_move_timer.is_stopped() and not dashing:
		animated_sprite.play("flip")
		velocity.x += direction * AIRSPEED
	
	#Limit speed
	if abs(velocity.x) > MAXSPEED and not dashing:
		if velocity.x > 0:
			velocity.x = MAXSPEED
		else:
			velocity.x = -MAXSPEED
	
	#Dash
	if Input.is_action_just_pressed("dash") and dash_ready and direction != 0:
		dash_ready = false
		dashing = true
		velocity.x = direction * DASH_SPEED
		dash_timer.start()
		animated_sprite.play("dash")
		$dash.play()
		
	if dashing:
		velocity.y = 0
	
	move_and_slide()
