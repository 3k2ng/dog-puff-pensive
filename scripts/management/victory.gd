extends CanvasLayer

const NO_RAP = preload("res://musics/win_short.wav")
const PUFF_RAP = preload("res://musics/reese's puffs rap.wav")

func _ready():
	if PlayerInfo.current_coin >= PlayerInfo.MAX_COIN:
		$Music.stream = PUFF_RAP
		$Background/Coins.text = "Wow, you got all three coins, dude!"
	else:
		$Music.stream = NO_RAP
		$Background/Coins.text = "Wow, you got %d coins!" % PlayerInfo.current_coin
	$Music.play()
	$Background/Time.text = "You beated the game in %.2f secs!" % PlayerInfo.current_timer

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var _success = get_tree().change_scene("res://scenes/game.tscn")
