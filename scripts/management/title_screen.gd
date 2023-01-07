extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		var _success = get_tree().change_scene("res://scenes/game.tscn")