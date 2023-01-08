extends Node

const MAX_HEALTH : int = 4
const MAX_COIN : int = 3

var current_health : int
var current_coin : int

var current_timer: float

var is_dead: bool = true

func init_health() -> void:
	current_health = MAX_HEALTH
	current_coin = 0
	current_timer = 0
	is_dead = false

func _process(delta: float) -> void:
	if not is_dead:
		current_timer += delta
