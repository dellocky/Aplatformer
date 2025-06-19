extends hitable_entity

# movement params
const SPEED       = 400
const JUMP_FORCE  = -400.0
var wall_jump_power = 800.0
var wall_slide_friction = 100
var is_wall_sliding = false
#dash params
var is_dashing = false
var dash_timer = 0.0  # Timer to track dash duration
var run_press_count_left = 0
var run_press_timer_left = 0.0
var run_press_count_right = 0
var run_press_timer_right = 0.0
const DASH_WINDOW = 0.2  #the window for which an additional left/right input counts for starting a dash in seconds
var dash_cooldown_time = 1.0  #this var controls dash cooldown duration in seconds
var dash_cooldown = 0.0 # this just makes the var, leave it alone
#wall jump params
var wall_jump_timer = 0.0  # Moved to class level
var wall_stick_timer = 0.0  # Timer for is wall jumping after a wall jump
var wall_jump_time = 0.25  # Duration to consider as wall jumping
var is_wall_jumping = false  # Track if the player has recently wall jumped
var wall_stick_time = 0  # makes the var, leave it alone
#animation params
const IDLE_SPEED = float(SPEED) / 40
var wait_for_idle = true
const TIME_FOR_IDLE = 2
var current_idle_time = 0
# input names
const INPUT_JUMP      = "jump"
const INPUT_RUN_RIGHT = "run_r"
const INPUT_RUN_LEFT  = "run_l"
const INPUT_DUCK      = "DUCK"

# cache your resources once
@onready var sprite       = $AnimatedSprite2D
@onready var jump_frames  = preload("res://scenes/player/animations/new_sprite_frames.tres")

func _ready() -> void:
	health = 100

# Add a timer to ensure print statements execute once per second
var time_since_last_print = 0.0

func _physics_process(delta):
	# ─── 1) PHYSICS ─────────────────────────────────────────
	#print (velocity.x)
	# vertical
	#wall_jump_timer += delta # Increment timer since last wall jump
	velocity.y = GravityProcessor.apply_gravity(velocity.y, is_on_floor(), delta)
	#wallslide
	#if is_on_wall():
		# Only start wall stick if we haven't wall jumped recently
	#	GravityProcessor.GRAVITY = lerp(150, 800, 0.9)  # Adjust gravity for wall stick
#	else:
	#	GravityProcessor.GRAVITY = 800  # Reset gravity when not on a wall

	# Handle jumping
	if Input.is_action_just_pressed(INPUT_JUMP):
		if is_on_floor():
			velocity.y = JUMP_FORCE
		elif is_on_wall():  # Changed to elif to avoid double jumping
			if Input.is_action_pressed(INPUT_RUN_RIGHT):
				velocity.y = JUMP_FORCE
				velocity.x = -wall_jump_power  # Set horizontal velocity for wall jump
				wall_stick_timer = wall_jump_time  # Force wall stick after wall jump
			elif Input.is_action_pressed(INPUT_RUN_LEFT):
				velocity.y = JUMP_FORCE
				velocity.x = wall_jump_power  # Set horizontal velocity for wall jump
				wall_stick_timer = wall_jump_time  # Force wall stick after wall jump

	if is_on_wall():
			print("is on wall")

	# Decrement wall stick timer
	if wall_stick_timer > 0:
		wall_stick_timer -= delta
		is_wall_jumping = true  #
		wall_stick_time = 1 #if a wall stick timer is started, start the wall stick time timer as well, which prevents vertical velocity for a short duration if the player is wall sliding after a wall jump
	else:
		is_wall_jumping = false
		wall_stick_time -= delta
	#wall slide
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed(INPUT_RUN_RIGHT) or Input.is_action_pressed(INPUT_RUN_LEFT):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		velocity.y = lerp(velocity.y, 0.0, delta * 5)  # Slow down vertical speed while wall sliding
		velocity.y += (wall_slide_friction * delta)  # reduce gravity effect while wall sliding
	if is_wall_sliding and wall_stick_time >= 0 and wall_stick_timer <= 0:
		velocity.y = 0  # Neutralize vertical velocity a short duration after landing from a wall jump
#logic for dash conditions
	if run_press_timer_right > 0:
		run_press_timer_right -= delta
	else:
		run_press_count_right = 0  # Reset if timer runs out

	if run_press_timer_left > 0:
		run_press_timer_left -= delta
	else:
		run_press_count_left = 0  # Reset if timer runs out

	if Input.is_action_just_pressed(INPUT_RUN_RIGHT):
		run_press_count_right += 1
		if run_press_count_right == 1:
			run_press_timer_right = DASH_WINDOW  # Start timer on first press
		elif run_press_count_right == 2 and run_press_timer_right > 0.0 and dash_cooldown <= 0.0:
			is_dashing = true
			dash_timer = 0.2  # Set dash duration
			run_press_count_right = 0  # Reset count after dash
			dash_cooldown = dash_cooldown_time  # Start dash cooldown
	if Input.is_action_just_pressed(INPUT_RUN_LEFT):
		run_press_count_left += 1
		if run_press_count_left == 1:
			run_press_timer_left = DASH_WINDOW  # Start timer on first press
		elif run_press_count_left == 2 and run_press_timer_left > 0.0 and dash_cooldown <= 0.0:
			is_dashing = true
			dash_timer = 0.2  # Set dash duration
			run_press_count_left = 0  # Reset count after dash
			dash_cooldown = dash_cooldown_time  # Start dash cooldown

	if Input.is_action_pressed(INPUT_RUN_RIGHT) and is_dashing:
		velocity.x = SPEED * 2  # Dash speed to the right
		velocity.y = 0  # Neutralize vertical velocity during dash
	elif Input.is_action_pressed(INPUT_RUN_LEFT) and is_dashing:
		velocity.x = -SPEED * 2  # Dash speed to the left
		velocity.y = 0  # Neutralize vertical velocity during dash
# Update dash timer
	if dash_timer > 0:
		dash_timer -= delta
	else:
		is_dashing = false  # Reset dash state when timer expires
	if dash_cooldown > 0:
		dash_cooldown -= delta

	# Handle horizontal movement
	if not is_wall_jumping:
		if Input.is_action_pressed(INPUT_RUN_RIGHT):
			if is_on_floor():
					velocity.x = lerp(velocity.x, float(SPEED), delta * 5)  # Gradually ramp up speed to max
			else:
					velocity.x = lerp(velocity.x, float(SPEED), delta * 2)  # horizontal change slower in the air
		elif Input.is_action_pressed(INPUT_RUN_LEFT):
			if is_on_floor():
					velocity.x = lerp(velocity.x, float(-SPEED), delta * 5)  # Gradually ramp up speed to max
			else:
					velocity.x = lerp(velocity.x, float(-SPEED), delta * 2)  # horizontal change slower in the air
		else:
				# ramp speed up/down depending on floor/air
			if is_on_floor():
					velocity.x = lerp(velocity.x, 0.0, 0.05)  # Slowdown on the ground for more momentum
			else:
					velocity.x = lerp(velocity.x, 0.0, 0.002)  # Even slower slowdown in the air for noticeable momentum

	# Handle ducking
	if Input.is_action_pressed(INPUT_DUCK):
			velocity.x = 0  # Stop horizontal movement while ducking
	# apply movement
	move_and_slide()

	# ─── 2) ANIMATION ───────────────────────────────────────
	if not is_on_floor():
		# always override with jump
		sprite.frames = jump_frames
		sprite.play("jump")
		# Ensure the sprite flips to face the direction of movement when jumping
		if velocity.x > 0:
			sprite.flip_h = true
		elif velocity.x < 0:
			sprite.flip_h = false
	elif abs(velocity.x) > IDLE_SPEED:
		# play run animation if velocity greater than 0, flip sprite based on direction
		sprite.play("run")
		sprite.flip_h = velocity.x > 0
		sprite.speed_scale = (abs(velocity.x) / SPEED / 4 * 3) + 0.25  # Adjust animation speed based on movement speed
		
	#elif Input.is_action_pressed(INPUT_DUCK):
		# ducking
		#sprite.play("duck")
		#sprite.flip_h = velocity.x > 0

	# Play idle animation when the player stops moving
	if is_on_floor() and abs(velocity.x) <= IDLE_SPEED:
		sprite.play("idle")
		sprite.speed_scale = 0  # stick on first frame of idle animation
		current_idle_time = current_idle_time + delta
		if current_idle_time >= TIME_FOR_IDLE:
			sprite.play("idle")
			sprite.speed_scale = 1  # Reset animation speed to normal
	else:
		current_idle_time = 0  # Reset idle time if player is moving
