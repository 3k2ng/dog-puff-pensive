extends KinematicBody2D

var max_health: int
var health: int
var velocity: Vector2

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	if health <= 0:
		_die()

func _physics_process(delta: float) -> void:
	move_and_slide(velocity)

func _die() -> void:
	pass

func hurt(dir: Vector2, damage: int) -> void:
	health -= damage
