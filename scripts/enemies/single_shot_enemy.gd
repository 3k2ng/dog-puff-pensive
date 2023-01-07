extends "res://scripts/enemies/enemy.gd"

const SPLASH: PackedScene = preload("res://objects/splash.tscn")
const PUFF: PackedScene = preload("res://objects/enemies/puff.tscn")

const HURT_SOUND: AudioStreamSample = preload("res://sfxs/01-chocolate hurt.wav")
const NOTICE_SOUND: AudioStreamSample = preload("res://sfxs/02-chocolate noticing.wav")
const SHOUTING_SOUND: AudioStreamSample = preload("res://sfxs/03-chocolate shouting.wav")
const STOMPING_SOUND: AudioStreamSample = preload("res://sfxs/04-chocolate stomping.wav")

enum {
	IDLE,
	HIT,
	CHASE,
	ATTACK
}

const MOVEMENT_SPEED = 16

const DETECTION_RANGE = 160 # 10 blocks
const ATTACK_RANGE = 160

const STUN_TIME = 0.1
const ATTACK_CD = 2

var direction: Vector2
var shoot_direction: Vector2

var target: KinematicBody2D
var state: int
var stun_timer: float
var attack_timer: float
var dead: bool

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
	max_health = 6
	._ready()

func _process(delta: float) -> void:
	._process(delta)
	
	if dead:
		return
	
	if state == HIT:
		if stun_timer > 0:
			stun_timer -= delta
			anim_playback.travel("hurt")
			return
		else:
			state = IDLE
	
	if attack_timer > 0:
		attack_timer -= delta
	
	if target:
		to_player.clear_exceptions()
		to_player.add_exception(target)
		for e in get_tree().get_nodes_in_group("enemy"):
			to_player.add_exception(e)
		to_player.cast_to = target.position - position
		if anim_playback.get_current_node() == "melee_attack" or (attack_timer <= 0 and to_player.cast_to.length() < ATTACK_RANGE and not to_player.is_colliding()):
			if attack_timer <= 0:
				play_sound(STOMPING_SOUND, true)
				attack_timer = ATTACK_CD
			state = ATTACK
		elif to_player.cast_to.length() > DETECTION_RANGE or to_player.is_colliding():
			anim_playback.travel("confused")
			state = IDLE
		else:
			# yes player detected
			anim_playback.travel("notice")
			if state != CHASE:
				play_sound(NOTICE_SOUND, false)
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
			play_sound(SHOUTING_SOUND, false)
			direction = to_player.cast_to.normalized()
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
	play_sound(HURT_SOUND, true)
	state = HIT
	stun_timer = STUN_TIME
	velocity = dir.normalized() * 32
	.hurt(dir, damage)

func splash() -> void:
	var new_splash = SPLASH.instance()
	new_splash.position = $MeleeBox/Shape.global_position
	SignalBus.emit_signal("spawn_object", new_splash)

func shoot() -> void:
	var new_puff = PUFF.instance()
	new_puff.position = position + shoot_direction * 16
	new_puff.state = 2 # LAUNCH
	new_puff.collision_layer = 2
	new_puff.collision_mask = 2
	new_puff.direction = shoot_direction
	SignalBus.emit_signal("spawn_object", new_puff)

func update_shoot_aim() -> void:
	shoot_direction = to_player.cast_to.normalized()
