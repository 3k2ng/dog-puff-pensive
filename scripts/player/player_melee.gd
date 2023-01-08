extends Area2D

const SWINGING_SOUND: AudioStreamMP3 = preload("res://sfxs/whoosh-6316.mp3")
const HITTING_SOUND: AudioStreamSample = preload("res://sfxs/06-hitting.wav")

onready var anim_playback = $AnimationTree.get("parameters/playback")

func _ready():
	var _success = self.connect("body_entered", self, "_body_entered")

func _body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.hurt(Vector2.RIGHT.rotated(rotation), 1)
		play_sound(HITTING_SOUND, true)
	if body.is_in_group("button"):
		body.activate()
		play_sound(HITTING_SOUND, true)
	

func _process(_delta: float) -> void:
	if Input.get_connected_joypads().size() > 0:
		rotation = Vector2.RIGHT.angle_to(Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized())
	else: 
		self.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("melee_attack"):
		anim_playback.travel("swing")

func _swing_start() -> void:
	play_sound(SWINGING_SOUND, true)
	$AnimatedSprite.flip_v = not $AnimatedSprite.flip_v

func play_sound(sfx: AudioStream, overriding: bool) -> void:
	if overriding or not $MeleeAudio.playing:
		$MeleeAudio.stream = sfx
		$MeleeAudio.play()
