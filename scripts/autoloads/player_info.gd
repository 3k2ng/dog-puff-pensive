extends Node

const MAX_HEALTH : int = 3

var current_health : int

var is_dead: bool

func init_health() -> void:
	current_health = MAX_HEALTH

func init_death():
	is_dead = false
