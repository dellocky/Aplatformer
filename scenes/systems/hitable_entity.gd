extends CharacterBody2D
class_name hitable_entity

var health = 1

func hit(damage, target):
	target.health = target.health - damage
