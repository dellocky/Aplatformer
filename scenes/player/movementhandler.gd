extends hitable_entity

# movement params
const SPEED       = 400
const JUMP_FORCE  = -400

#animation params
const IDLE_SPEED = SPEED / 40
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

func _physics_process(delta):
	# ─── 1) PHYSICS ─────────────────────────────────────────
	#print (velocity.x)
	# vertical
	velocity.y = GravityProcessor.apply_gravity(velocity.y, is_on_floor(), delta)
	
	if Input.is_action_just_pressed(INPUT_JUMP) and is_on_floor():
			velocity.y = JUMP_FORCE

	# Handle jumping
	if Input.is_action_just_pressed(INPUT_JUMP) and is_on_floor():
		velocity.y = JUMP_FORCE
		$AnimatedSprite2D.frames = preload("res://scenes/player/animations/new_sprite_frames.tres")
		$AnimatedSprite2D.play("jump")  # Ensure the animation is played

	# Handle horizontal movement

	if Input.is_action_pressed(INPUT_RUN_RIGHT):
		velocity.x = lerp(velocity.x, float(SPEED), delta * 5)  # Gradually ramp up speed to max
		$AnimatedSprite2D.frames = preload("res://scenes/player/animations/new_sprite_frames.tres")
		$AnimatedSprite2D.flip_h = true  # Ensure the animation is flipped
		$AnimatedSprite2D.play("run")  # Ensure the animation is played
	elif Input.is_action_pressed(INPUT_RUN_LEFT):
		velocity.x = lerp(velocity.x, float(-SPEED), delta * 5)  # Gradually ramp up speed to max
		$AnimatedSprite2D.frames = preload("res://scenes/player/animations/new_sprite_frames.tres")
		$AnimatedSprite2D.flip_h = false  # not flipped anim
		$AnimatedSprite2D.play("run")  # Ensure the animation is played
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
	
	
