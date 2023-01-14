extends CanvasLayer

func _ready():
	if PlayerInfo.current_coin >= PlayerInfo.MAX_COIN:
		$AudioStreamPlayer.play()
		$Background/Coins.text = "Wow, you got all three coins, dude!"
	else:
		$Background/Coins.text = "Wow, you got %d coins!" % PlayerInfo.current_coin
	$Background/Time.text = "You beated the game in %.2f secs!" % PlayerInfo.current_timer

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var _success = get_tree().change_scene("res://scenes/game.tscn")
