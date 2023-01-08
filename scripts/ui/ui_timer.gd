extends Label

func _process(delta: float) -> void:
	text = "Timer: %.2f sec" % PlayerInfo.current_timer
