extends "res://scripts/enemies/enemy.gd"

const SPLASH: PackedScene = preload("res://objects/splash.tscn")
const EXPLOSION: PackedScene = preload("res://objects/explosion.tscn")
const LASER: PackedScene = preload("res://objects/enemy_laser.tscn")

const EXPLOSION_SOUND = preload("res://sfxs/07-puff explode.wav")
const EXPLODING_SOUND: AudioStreamSample = preload("res://sfxs/08-puff fuse.wav")
const HURT_SOUND: AudioStreamSample = preload("res://sfxs/09-puff hurt.wav")
const NOTICE_SOUND: AudioStreamSample = preload("res://sfxs/10-puff noticing.wav")
const SHOUTING_SOUND: AudioStreamSample = preload("res://sfxs/11-puff shouting.wav")

enum {
	IDLE,
	HIT,
	LAUNCH,
	CHASE,
	ATTACK
}

const MOVEMENT_SPEED = 64
const LAUNCH_SPEED = 96.0

const DETECTION_RANGE = 160 # 10 blocks
const ATTACK_RANGE = 160

const STUN_TIME = 0.2
const ATTACK_CD = 2

var direction: Vector2
var laser_direction: Vector2

var target: KinematicBody2D
var state: int
var stun_timer: float
var attack_timer: float

onready var to_player: RayCast2D = $ToPlayer
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_playback = $AnimationTree.get("parameters/playback")
onready var trail: Particles2D = $Trail

func get_player_as_target() -> void:
	var player_group: Array = get_tree().get_nodes_in_group("player")
	if len(player_group) > 0:
		target = get_tree().get_nodes_in_group("player")[0]
		# activate raycast
		to_player.enabled = true

func _process(delta: float) -> void:
	if state == HIT:
		if stun_timer > 0:
			stun_timer -= delta
			anim_playback.travel("hurt")
			return
		else:
			state = LAUNCH
			trail.emitting = true
			anim_playback.travel("launch")
	
	if state == LAUNCH:
		play_sound(SHOUTING_SOUND, false)
		collision_layer = 2
		collision_mask = 2
		return
	
	if attack_timer > 0:
		attack_timer -= delta
	
	if target:
		to_player.clear_exceptions()
		to_player.add_exception(target)
		for e in get_tree().get_nodes_in_group("enemy"):
			to_player.add_exception(e)
		to_player.cast_to = target.position - position
		if to_player.cast_to.length() < ATTACK_RANGE and not to_player.is_colliding():
			if attack_timer <= 0:
				play_sound(EXPLODING_SOUND, true)
				anim_playback.travel("fire")
				attack_timer = ATTACK_CD
			state = ATTACK
		elif to_player.cast_to.length() > DETECTION_RANGE or to_player.is_colliding():
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
			direction = Vector2.ZERO
		CHASE:
			anim_playback.travel("chase")
			play_sound(SHOUTING_SOUND, false)
			direction = to_player.cast_to.normalized()

func _physics_process(delta: float) -> void:
	if state == LAUNCH:
		velocity = direction * LAUNCH_SPEED
		if velocity.x < 0:
			anim_sprite.flip_h = true
			rotation = Vector2.LEFT.angle_to(direction)
		elif velocity.x > 0:
			anim_sprite.flip_h = false
			rotation = Vector2.RIGHT.angle_to(direction)
		var collision = move_and_collide(velocity * delta)
		if collision:
			splash()
		return
	if state != HIT:
		._physics_process(delta)
		velocity = direction * MOVEMENT_SPEED
		if velocity.x < 0:
			anim_sprite.flip_h = true
		elif velocity.x > 0:
			anim_sprite.flip_h = false

func _ready() -> void:
	get_player_as_target()

func laser() -> void:
	play_sound(EXPLOSION_SOUND, true)
	var new_laser = LASER.instance()
	new_laser.position = global_position + laser_direction.normalized() * 8
	new_laser.direction = laser_direction.normalized()
	SignalBus.emit_signal("spawn_object", new_laser)

func splash() -> void:
	var new_splash = SPLASH.instance()
	new_splash.position = global_position
	SignalBus.emit_signal("spawn_object", new_splash)
	var new_explosion = EXPLOSION.instance()
	new_explosion.position = global_position
	SignalBus.emit_signal("spawn_object", new_explosion)
	queue_free()

func hurt(dir: Vector2, _damage: int) -> void:
	$FlashPlayer.play("flash")
	play_sound(HURT_SOUND, true)
	state = HIT
	stun_timer = STUN_TIME
	velocity = Vector2.ZERO
	direction = dir.normalized()

func update_laser_aim() -> void:
	laser_direction = to_player.cast_to.normalized()
