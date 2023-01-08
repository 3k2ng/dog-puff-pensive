extends KinematicBody2D

const GETTING_HIT_SOUND: AudioStreamSample = preload("res://sfxs/05-getting hit.wav")
const ROLLING_SOUND: AudioStreamSample = preload("res://sfxs/12-rolling.wav")

export var movement_speed: float = 64.0
export var rolling_speed_multiplier: float = 2

export var hurt_invulnerable_time: float = 2.0
export var stun_time: float = 0.1
const ROLL_TIME: float = 0.75

var is_facing_up: bool

var direction: Vector2
var velocity: Vector2
var roll_direction: Vector2

var stun_timer: float
var roll_timer: float
var invulnerability_timer: float
var is_rolling: bool = false


onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_playback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	PlayerInfo.init_health()

func _process(delta: float) -> void:
	if PlayerInfo.is_dead:
		return

	if(invulnerability_timer >= 0):
		invulnerability_timer -= delta

	if Input.is_action_just_pressed("dodge_roll") and not is_rolling:
		if is_facing_up:
			anim_playback.travel("roll_up")
		else:
			anim_playback.travel("roll_side")
		# roll_timer = ROLL_TIME
		is_rolling = true
	
	if not is_rolling:
		# roll_timer -= delta
		# if is_facing_up:
		# 	anim_playback.travel("roll_up")
		# else:
		# 	anim_playback.travel("roll_side")
	# else:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		if direction != Vector2.ZERO:
			roll_direction = direction
		
		if direction.x > 0:
			anim_sprite.flip_h = false
		elif direction.x < 0:
			anim_sprite.flip_h = true
		
		if direction.length() > 0:
			if direction.y < -sqrt(0.5):
				is_facing_up = true
			else:
				is_facing_up = false
			if is_facing_up:
				anim_playback.travel("run_up")
			else:
				anim_playback.travel("run_side")
		else:
			if is_facing_up:
				anim_playback.travel("idle_up")
			else:
				anim_playback.travel("idle")

func _physics_process(delta: float) -> void:
	if stun_timer > 0:
		stun_timer -= delta
	elif is_rolling:
		velocity = roll_direction * movement_speed * rolling_speed_multiplier
	else:
		velocity = direction * movement_speed
	velocity = move_and_slide(velocity)

func damage_taken(dir: Vector2, _damage: int):
	if PlayerInfo.current_health <= 0:
		return
	if(invulnerability_timer > 0):
		return
	
	is_rolling = false
	$FlashPlayer.play("flash")
	anim_playback.travel("dog_hurt")
	stun_timer = stun_time
	velocity = dir.normalized() * movement_speed * 2
	play_sound(GETTING_HIT_SOUND, true)
	PlayerInfo.current_health -= 1
	if PlayerInfo.current_health <= 0:
		die()
	else:
		invulnerability_timer = hurt_invulnerable_time
	

func play_sound(sfx: AudioStream, overriding: bool) -> void:
	if overriding or not $MeleeAudio.playing:
		$Audio.stream = sfx
		$Audio.play()

func die():
	PlayerInfo.is_dead = true
	velocity = Vector2.ZERO
	yield(get_tree().create_timer(0.6), "timeout")
	var _success = get_tree().change_scene("res://scenes/game_over.tscn")

func start_roll():
	play_sound(ROLLING_SOUND, true)

func end_roll():
	is_rolling = false
