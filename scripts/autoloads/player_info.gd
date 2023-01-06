extends Node

const MAX_HEALTH : int = 30
const MAX_COIN : int = 4

var current_health : int
var current_coin : int

var is_dead: bool

func init_health() -> void:
	current_health = MAX_HEALTH
	current_coin = 0
