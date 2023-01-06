extends KinematicBody2D

const GETTING_HIT_SOUND: AudioStreamSample = preload("res://sfxs/05-getting hit.wav")
const ROLLING_SOUND: AudioStreamSample = preload("res://sfxs/12-rolling.wav")

const MOVEMENT_SPEED: float = 64.0
const ROLLING_SPEED: float = 128.0

const STUN_TIME: float = 0.2
const ROLL_TIME: float = 0.5

var is_facing_up: bool

var direction: Vector2
var velocity: Vector2

var stun_timer: float
var roll_timer: float


onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_playback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	PlayerInfo.init_health()
	PlayerInfo.init_death()

func _process(delta: float) -> void:
	if PlayerInfo.is_dead:
		return
	if Input.is_action_just_pressed("dodge_roll") and roll_timer <= 0:
		roll_timer = ROLL_TIME
		play_sound(ROLLING_SOUND, true)
	
	if roll_timer > 0:
		roll_timer -= delta
		if is_facing_up:
			anim_playback.travel("roll_up")
		else:
			anim_playback.travel("roll_side")
	else:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		
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
	elif roll_timer <= 0:
		velocity = direction * MOVEMENT_SPEED
	else:
		velocity = direction * ROLLING_SPEED
	move_and_slide(velocity)

func damage_taken(dir: Vector2, damage: int):
	$FlashPlayer.play("flash")
	$AnimationPlayer.play("dog_hurt")
	stun_timer = STUN_TIME
	velocity = dir.normalized() * MOVEMENT_SPEED * 2
	play_sound(GETTING_HIT_SOUND, true)
	PlayerInfo.current_health -= 1
	die()
	print(PlayerInfo.current_health)
	

func play_sound(sfx: AudioStream, overriding: bool) -> void:
	if overriding or not $MeleeAudio.playing:
		$Audio.stream = sfx
		$Audio.play()

func die():
	if PlayerInfo.current_health <= 0:
		PlayerInfo.is_dead = true
		velocity = Vector2.ZERO
		get_tree().change_scene("res://scenes/game_over.tscn")
		
	
