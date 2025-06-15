extends CharacterBody2D

func _physics_process(delta):
	velocity.y = GravityProcessor.apply_gravity(velocity.y, is_on_floor(), delta)
	
