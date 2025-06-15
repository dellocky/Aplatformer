extends CharacterBody2D
class_name hitable_entity

var health = 1
var damage = 0

func hit(damage, target):
	target.health = target.health - damage
