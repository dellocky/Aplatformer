extends hitable_entity

var touching_right_wall = false
var touching_left_wall = false
var GRAVITY = 800
var time_since_last_print = 0.0

func apply_gravity(v_y: float, on_floor: bool, delta: float) -> float:
	if not on_floor:
		v_y += GRAVITY * delta
	return v_y

func detect_wall_collision():
	# Reset wall contact variables
	touching_left_wall = false
	touching_right_wall = false

	# Get all collisions
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		
		# Check wall collisions
		if abs(normal.x) > 1:  # Using a threshold for near-vertical walls
			if normal.x > 0:  # Right normal means left wall
				touching_left_wall = true
			else:  # Left normal means right wall
				touching_right_wall = true

func _physics_process(_delta):
	detect_wall_collision()
	
	if time_since_last_print >= 1.0:
		print("Wall status - Left:", touching_left_wall, " Right:", touching_right_wall)
		time_since_last_print = 0.0
