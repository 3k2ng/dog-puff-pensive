extends "res://scripts/enemies/enemy.gd"

const SPLASH: PackedScene = preload("res://objects/splash.tscn")

enum {
	IDLE,
	HIT,
	CHASE,
	ATTACK
}

const MOVEMENT_SPEED = 32

const DETECTION_RANGE = 160 # 10 blocks
const ATTACK_RANGE = 20
const CLOSEST_DIST = 1 # closest distance needed to consider arrived at last know player location

const STUN_TIME = 0.1

var direction: Vector2
var last_known_location: Vector2 # location of player last time seen

var target: KinematicBody2D
var state: int
var stun_timer: float
var dead: bool

onready var to_player: RayCast2D = $ToPlayer
onready var health_bar: TextureProgress = $HealthBar
onready var anim_sprite: AnimatedSprite = $Sprite
onready var anim_playback = $AnimationTree.get("parameters/playback")

func get_player_as_target() -> void:
	var player_group: Array = get_tree().get_nodes_in_group("player")
	if len(player_group) > 0:
		target = get_tree().get_nodes_in_group("player")[0]
		# activate raycast
		to_player.add_exception(target)
		to_player.enabled = true

func _die() -> void:
	dead = true
	velocity = Vector2.ZERO
	anim_playback.travel("dead")

func _ready() -> void:
	get_player_as_target()
	max_health = 3
	health_bar.max_value = max_health
	._ready()

func _process(delta: float) -> void:
	._process(delta)
	health_bar.value = health
	
	if dead:
		return
	
	if state == HIT:
		if stun_timer > 0:
			stun_timer -= delta
			anim_playback.travel("hurt")
			return
		else:
			state = IDLE
	
	if target:
		to_player.cast_to = target.position - position
		if anim_playback.get_current_node() == "melee_attack" or (to_player.cast_to.length() < ATTACK_RANGE and not to_player.is_colliding()):
			state = ATTACK
		elif to_player.cast_to.length() > DETECTION_RANGE or to_player.is_colliding():
			if position.distance_to(last_known_location) < 1:
				anim_playback.travel("confused")
				state = IDLE
		else:
			# yes player detected
			last_known_location = target.position
			anim_playback.travel("notice")
			state = CHASE
	else:
		get_player_as_target()
	
	match state:
		IDLE:
			anim_playback.travel("idle")
			direction = Vector2.ZERO
		ATTACK:
			anim_playback.travel("melee_attack")
			direction = Vector2.ZERO
		CHASE:
			anim_playback.travel("chase")
			direction = position.direction_to(last_known_location).normalized()
			$MeleeBox.rotation = Vector2.RIGHT.angle_to(direction)

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	if state != HIT:
		velocity = direction * MOVEMENT_SPEED
		if velocity.x < 0:
			anim_sprite.flip_h = true
		elif velocity.x > 0:
			anim_sprite.flip_h = false

func hurt(dir: Vector2, damage: int) -> void:
	$FlashPlayer.play("flash")
	state = HIT
	stun_timer = STUN_TIME
	velocity = dir.normalized() * 32
	.hurt(dir, damage)

func splash() -> void:
	var new_splash = SPLASH.instance()
	new_splash.position = $MeleeBox/Shape.global_position
	SignalBus.emit_signal("spawn_object", new_splash)
