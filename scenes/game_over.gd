extends CanvasLayer


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and PlayerInfo.is_dead:
		get_tree().change_scene("res://scenes/demo_tung.tscn")
