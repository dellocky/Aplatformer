extends CharacterBody2D

# Define constants for movement
const SPEED = 400
const JUMP_FORCE = -400
const GRAVITY = 800

# Define input actions
const INPUT_JUMP = "jump"
const INPUT_DUCK = "duck"
const INPUT_RUN_RIGHT = "run_r"
const INPUT_RUN_LEFT = "run_l"

func _physics_process(delta):
	# Apply gravity only if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on the floor

	# Handle horizontal movement
	if Input.is_action_pressed(INPUT_RUN_RIGHT):
		velocity.x = lerp(velocity.x, float(SPEED), delta * 5)  # Gradually ramp up speed to max
	elif Input.is_action_pressed(INPUT_RUN_LEFT):
		velocity.x = lerp(velocity.x, float(-SPEED), delta * 5)  # Gradually ramp up speed to max
	else:
		# Apply friction based on whether the player is on the floor
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, 0.05)  # Slowdown on the ground for more momentum
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.002)  # Even slower slowdown in the air for noticeable momentum

	# Handle jumping
	if Input.is_action_just_pressed(INPUT_JUMP) and is_on_floor():
		velocity.y = JUMP_FORCE

	# Handle ducking
	if Input.is_action_pressed(INPUT_DUCK):
		velocity.x = 0  # Stop horizontal movement while ducking

	# Move the character
	move_and_slide()
