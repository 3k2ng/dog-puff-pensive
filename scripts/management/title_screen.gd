extends CanvasLayer


func _ready():
	$Play.grab_focus()
	var _success = $Play.connect("button_down", self, "play")

func play():
	var _success = get_tree().change_scene("res://scenes/game.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		play()