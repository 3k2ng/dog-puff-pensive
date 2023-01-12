extends KinematicBody2D

const GETTING_HIT_SOUND: AudioStreamSample = preload("res://sfxs/05-getting hit.wav")
const ROLLING_SOUND: AudioStreamSample = preload("res://sfxs/12-rolling.wav")

export var movement_speed: float = 64.0
export var rolling_speed_multiplier: float = 2

export var hurt_invulnerable_time: float = 2.0
export var stun_time: float = 0.1
export var roll_time: float = 0.58

var anim_direction_string: String = "_side"

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

	if invulnerability_timer >= 0:
		invulnerability_timer -= delta

	if Input.is_action_just_pressed("dodge_roll") and not is_rolling:
		anim_playback.travel("roll")
		set_animation("roll")
		roll_timer = roll_time
		is_rolling = true
	
	if not is_rolling:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		roll_direction = direction
		
		if direction.x > 0:
			anim_sprite.flip_h = false
		elif direction.x < 0:
			anim_sprite.flip_h = true
		
		if direction.length() > 0:
			get_anim_direction_string()

			anim_playback.travel("run")
			set_animation("run")
		else:
			anim_playback.travel("idle")
			set_animation("idle")

	else:
		if roll_timer > 0:
			roll_timer -= delta
		else:
			is_rolling = false
		if roll_direction == Vector2.ZERO:
			direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
			roll_direction = direction
			if(direction.length() > 0):
				get_anim_direction_string()


func get_anim_direction_string() -> void:
	var direction_angle

	if is_rolling:
		direction_angle = roll_direction.angle() / PI
	else:
		direction_angle = direction.angle() / PI

	if (direction_angle <= -3/8.0 and direction_angle >= -5/8.0):
		anim_direction_string = "_vert"
	elif (direction_angle >= 3/8.0 and direction_angle <= 5/8.0):
		anim_direction_string = "_down"
	elif (direction_angle <= -1/8.0 and direction_angle >= -7/8.0):
		anim_direction_string = "_up"
	else:
		anim_direction_string = "_side"

func set_animation(animation_root: String) -> void:
	anim_sprite.animation = animation_root + anim_direction_string


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
	if invulnerability_timer > 0:
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
