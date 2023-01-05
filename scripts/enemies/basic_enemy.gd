extends "res://scripts/enemies/enemy.gd"

enum {
	IDLE,
	CHASE,
	ATTACK
}

const MOVEMENT_SPEED = 32

const DETECTION_RANGE = 160 # 10 blocks
const ATTACK_RANGE = 16


var direction: Vector2

var target: KinematicBody2D

var state: int

onready var to_player: RayCast2D = $ToPlayer
onready var health_bar: TextureProgress = $HealthBar
onready var sprite: AnimatedSprite = $Sprite

func get_player_as_target() -> void:
	var player_group: Array = get_tree().get_nodes_in_group("player")
	if len(player_group) > 0:
		target = get_tree().get_nodes_in_group("player")[0]
		# activate raycast
		to_player.add_exception(target)
		to_player.enabled = true

func _ready() -> void:
	get_player_as_target()
	max_health = 3
	health_bar.max_value = max_health
	._ready()

func _process(delta: float) -> void:
	._process(delta)
	
	if target:
		to_player.cast_to = target.position - position
		if $AnimationPlayer.is_playing() or to_player.cast_to.length() < ATTACK_RANGE:
			state = ATTACK
		elif to_player.cast_to.length() > DETECTION_RANGE or to_player.is_colliding():
			# no player detected
			state = IDLE
		else:
			# yes player detected
			state = CHASE
	else:
		get_player_as_target()
	
	match state:
		IDLE:
			direction = Vector2.ZERO
			sprite.play("default")
		ATTACK:
			direction = Vector2.ZERO
			$AnimationPlayer.play("melee_attack")
		CHASE:
			$MeleeBox.rotation = Vector2.RIGHT.angle_to(to_player.cast_to)
			direction = to_player.cast_to.normalized()
			sprite.play("chase")
	
	health_bar.value = health

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	velocity = direction * MOVEMENT_SPEED
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func hurt(dir: Vector2, damage: int) -> void:
	$FlashPlayer.play("flash")
	.hurt(dir, damage)
