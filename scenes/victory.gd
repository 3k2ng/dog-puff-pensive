extends CanvasLayer

func _ready():
	if PlayerInfo.current_coin >= PlayerInfo.MAX_COIN:
		$AudioStreamPlayer.play()
		$Background/Coins.text = "Wow, you got all three coins, dude!"
	else:
		$Background/Coins.text = "Wow, you got %d coins!" % PlayerInfo.current_coin

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/game.tscn")
