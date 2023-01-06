extends KinematicBody2D

export var id: String

var max_health: int
var health: int
var velocity: Vector2

func _ready() -> void:
	health = max_health

func _process(_delta: float) -> void:
	if health <= 0:
		_die()

func _physics_process(_delta: float) -> void:
	move_and_slide(velocity)

func _die() -> void:
	pass

func hurt(_dir: Vector2, damage: int) -> void:
	health -= damage

func play_sound(sfx: AudioStream, override: bool) -> void:
	if override or not $Audio.playing:
		$Audio.stream = sfx
		$Audio.play()
