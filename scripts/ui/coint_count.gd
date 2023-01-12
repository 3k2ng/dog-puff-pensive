extends Label

func _process(_delta: float) -> void:
	text = "Coins: %d" % PlayerInfo.current_coin
