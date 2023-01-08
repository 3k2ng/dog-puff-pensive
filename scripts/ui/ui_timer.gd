extends Label

func _process(_delta: float) -> void:
	text = "Timer: %.2f sec" % PlayerInfo.current_timer
