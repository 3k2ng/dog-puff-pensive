extends CanvasLayer


func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var _success = get_tree().change_scene("res://scenes/game.tscn")
