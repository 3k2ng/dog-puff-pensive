extends Label

func _process(_delta: float) -> void:
	text = " %.2f secs" % PlayerInfo.current_timer
