extends Area2D

const PICKUP_SOUND: AudioStreamSample = preload("res://sfxs/pickup.wav")

const LIFETIME_AFTER_PICKUP: float = 0.6

var lifetime: float
var picked_up: bool = false

func _ready():
	$AnimatedSprite.play("default")

func _process(delta: float) -> void:
	if picked_up:
		if lifetime > 0:
			lifetime -= delta
		else:
			queue_free()

func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite.play("collect")
		PlayerInfo.current_coin += 1
		$Audio.stream = PICKUP_SOUND
		$Audio.play()
		$Shape.disabled = true
		picked_up = true
		lifetime = LIFETIME_AFTER_PICKUP
