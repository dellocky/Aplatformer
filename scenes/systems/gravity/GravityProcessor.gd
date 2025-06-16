extends hitable_entity

var GRAVITY = 800

func apply_gravity(v_y: float, on_floor: bool, delta: float) -> float:
	if not on_floor:
		v_y += GRAVITY * delta
	return v_y
