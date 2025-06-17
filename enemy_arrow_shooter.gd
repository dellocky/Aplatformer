extends hitable_entity

const SPEED = 287.5
const RUN_DISTANCE = 350
const SHOOT_DISTANCE = 600
const AGGRO_DISTANCE = 1200
const ATTACK_SPEED = 1.5
var speed_normalized

var player
var direction_vector = 2
var direction_face = "left"
var attack_timer

var arrow_scene := preload("res://scenes/enemies/arrow.tscn")
func _ready():
	player = $"../Player"
	
	
func _physics_process(delta):
	get_direction()
	velocity.y = GravityProcessor.apply_gravity(velocity.y, is_on_floor(), delta)
	speed_normalized = SPEED * direction_vector
	if speed_normalized == 0:
		velocity.x = 0
	else:
		velocity.x =  lerp(velocity.x, float(speed_normalized), delta * 5)
	move_and_slide()
	
func get_direction():
	if abs(position.x - player.position.x) < RUN_DISTANCE:
		if position.x > player.position.x:
			direction_vector = 1
			direction_face = "left"

		else:
			direction_vector = -1
			direction_face = "right"
			
	elif abs(position.x - player.position.x) > SHOOT_DISTANCE:
		if position.x > player.position.x:
			direction_vector = -1
			direction_face = "left"

		else:
			direction_vector = 1
			direction_face = "right"
	else:
		direction_vector = 0
	
	

func attack():
	pass
	

		
		
