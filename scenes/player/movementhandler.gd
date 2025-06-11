extends CharacterBody2D

# Define constants for movement
const SPEED = 200
const JUMP_FORCE = -400
const GRAVITY = 800

# Define input actions
const INPUT_JUMP = "jump"
const INPUT_DUCK = "duck"
const INPUT_RUN_RIGHT = "run_r"
const INPUT_RUN_LEFT = "run_l"

func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Handle horizontal movement
	if Input.is_action_pressed(INPUT_RUN_RIGHT):
		velocity.x = SPEED
	elif Input.is_action_pressed(INPUT_RUN_LEFT):
		velocity.x = -SPEED
	else:
		velocity.x = 0

	# Handle jumping
	if Input.is_action_just_pressed(INPUT_JUMP) and is_on_floor():
		velocity.y = JUMP_FORCE

	# Handle ducking
	if Input.is_action_pressed(INPUT_DUCK):
		velocity.x = 0  # Stop horizontal movement while ducking

	# Move the character
	move_and_slide()
