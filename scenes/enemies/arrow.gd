extends CharacterBody2D
const BASE_SPEED = 1125
const DESPAWN_TIME = 1.5

var momentum = 0
var active = true
var despawn_timer = 0
var direction = 1

func _ready() -> void:
	velocity.x = (BASE_SPEED + momentum) * direction
	velocity.y = -125

func _physics_process(delta):
	velocity.y = GravityProcessor.apply_gravity(velocity.y, is_on_floor(), delta)
	move_and_slide()
	for i in range(get_slide_collision_count()):
		velocity.x = 0
	
	if velocity.x == 0 and velocity.y == 0:
		active = false
	
	if active == false:
		despawn_timer += delta
		modulate.a = ((DESPAWN_TIME - despawn_timer)/DESPAWN_TIME)
		if despawn_timer >= DESPAWN_TIME:
			queue_free()


	

		
