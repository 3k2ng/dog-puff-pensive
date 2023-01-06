extends Area2D

const SWINGING_SOUND: AudioStreamMP3 = preload("res://sfxs/whoosh-6316.mp3")
const HITTING_SOUND: AudioStreamSample = preload("res://sfxs/06-hitting.wav")

var alt_side: bool

func _ready():
	self.connect("body_entered", self, "_body_entered")
	$MeleePlayer.connect("animation_finished", self, "_swing_finish")

func _body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.hurt(Vector2.RIGHT.rotated(rotation), 1)
		play_sound(HITTING_SOUND, true)
	if body.is_in_group("button"):
		body.activate()
		play_sound(HITTING_SOUND, true)
	

func _process(delta: float) -> void:
	if Input.get_connected_joypads().size() > 0:
		rotation = Vector2.RIGHT.angle_to(Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized())
	else: 
#		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		self.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("melee_attack"):
		if not $MeleePlayer.is_playing():
			play_sound(SWINGING_SOUND, true)
		$MeleePlayer.play("swing")

func _swing_finish(anim_name: String) -> void:
	if anim_name == "swing":
		alt_side = not alt_side
		$AnimatedSprite.flip_v = alt_side
		$AnimatedSprite.frame = 0

func play_sound(sfx: AudioStream, overriding: bool) -> void:
	if overriding or not $MeleeAudio.playing:
		$MeleeAudio.stream = sfx
		$MeleeAudio.play()
