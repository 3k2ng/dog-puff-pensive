extends Area2D

const EXPLOSION_SOUND = preload("res://sfxs/07-puff explode.wav")

func _ready() -> void:
	self.connect("body_entered", self, "on_body_entered")
	$Audio.stream = EXPLOSION_SOUND
	$Audio.play()

func on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage_taken((body.position - position).normalized(), 1)
	elif body.is_in_group("enemy"):
		body.hurt((body.position - position).normalized(), 1)
	elif body.is_in_group("button"):
		body.activate()

func _process(delta: float) -> void:
	if $Timer.is_stopped():
		$Shape.disabled = true
	if $Shape.disabled and $Audio.playing:
		queue_free()
