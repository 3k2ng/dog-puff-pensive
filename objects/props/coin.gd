extends Area2D

const PICKUP_SOUND: AudioStreamSample = preload("res://sfxs/pickup.wav")

func _ready():
	$AnimatedSprite.play("default")

func _on_Coin_body_entered(body):
	$AnimatedSprite.play("collect")
	PlayerInfo.current_coin += 1
	$Audio.stream = PICKUP_SOUND
	$Audio.play()
	if body.is_in_group("player"):
		yield(get_tree().create_timer(0.6), "timeout")
	queue_free()
