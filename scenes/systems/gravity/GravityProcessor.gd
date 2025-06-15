extends CharacterBody2D

var GRAVITY = 800

func apply_gravity(v_y: float, is_on_floor: bool, delta: float) -> float:
	if not is_on_floor:
		v_y += GRAVITY * delta
	return v_y
