extends "res://scripts/enemies/enemy.gd"

const SPLASH: PackedScene = preload("res://objects/macaron_splash.tscn")
const PUFF: PackedScene = preload("res://objects/enemies/puff.tscn")

const HURT_SOUND: AudioStreamSample = preload("res://sfxs/01-macaron_hurt.wav")
const STOMPING_SOUND: AudioStreamSample = preload("res://sfxs/02-macaron_slam.wav")

enum {
	IDLE,
	HIT,
	CHASE,
	ATTACK
}

const DETECTION_RANGE = 160 # 10 blocks
const ATTACK_RANGE = 80

const STUN_TIME = 0.2
const ATTACK_CD = 1
const SPAWN_CD = 0.75

var target: KinematicBody2D
var state: int
var stun_timer: float
var attack_timer: float
var spawn_timer: float
var dead: bool
var can_spawn: bool

onready var to_player: RayCast2D = $ToPlayer
onready var anim_sprite: AnimatedSprite = $Sprite
onready var anim_playback = $AnimationTree.get("parameters/playback")

func get_player_as_target() -> void:
	var player_group: Array = get_tree().get_nodes_in_group("player")
	if len(player_group) > 0:
		target = get_tree().get_nodes_in_group("player")[0]
		# activate raycast
		to_player.enabled = true

func _die() -> void:
	dead = true
	velocity = Vector2.ZERO
	anim_playback.travel("dead")
	$Shape.disabled = true

func _ready() -> void:
	get_player_as_target()
	max_health = 16
	can_spawn = true;
	._ready()

func _process(delta: float) -> void:
	._process(delta)
	
	if dead:
		return
	
	if state == HIT:
		if stun_timer > 0:
			stun_timer -= delta
			anim_playback.travel("hurt")
			can_spawn = true;
			return
		else:
			state = IDLE
			# enable_spawn()
	
	if attack_timer > 0:
		attack_timer -= delta

	if spawn_timer > 0:
		spawn_timer -= delta
		# if spawn_timer <= 0:
		# 	enable_spawn()
	
	if target:
		to_player.clear_exceptions()
		to_player.add_exception(target)
		for e in get_tree().get_nodes_in_group("enemy"):
			to_player.add_exception(e)
		to_player.cast_to = target.position - position
		if anim_playback.get_current_node() == "melee_attack" or (attack_timer <= 0 and to_player.cast_to.length() < ATTACK_RANGE):
			if attack_timer <= 0:
				play_sound(STOMPING_SOUND, true)
				attack_timer = ATTACK_CD
			state = ATTACK
		elif to_player.cast_to.length() > DETECTION_RANGE or to_player.is_colliding():
			anim_playback.travel("confused")
			state = IDLE
			# enable_spawn()
		elif spawn_timer <= 0:
			# yes player detected
			spawn_timer = SPAWN_CD
			state = CHASE
	else:
		get_player_as_target()
	
	match state:
		IDLE:
			anim_playback.travel("idle")
		ATTACK:
			anim_playback.travel("melee_attack")
		CHASE:
			anim_playback.travel("spawn")

func hurt(dir: Vector2, damage: int) -> void:
	$FlashPlayer.play("flash")
	play_sound(HURT_SOUND, true)
	state = HIT
	stun_timer = STUN_TIME
	.hurt(dir, damage)

func splash() -> void:
	var new_splash = SPLASH.instance()
	new_splash.position = $MeleeBox/Shape.global_position
	SignalBus.emit_signal("spawn_object", new_splash)

func spawn() -> void:
	# if not can_spawn:
	# 	return
	var new_puff = PUFF.instance()
	new_puff.position = $Spawn_Position.global_position
	# new_puff.state = 0 # LAUNCH
	new_puff.collision_layer = 2
	new_puff.collision_mask = 2
	new_puff.direction = to_player.cast_to.normalized()
	SignalBus.emit_signal("spawn_object", new_puff)
	anim_playback.travel("idle")
	# can_spawn = false;

# func enable_spawn():
# 	can_spawn = true;
