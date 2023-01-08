extends CanvasLayer


func _ready():
	$Play.grab_focus()
	var _success = $Play.connect("button_down", self, "play")
	_success = $Quit.connect("button_down", self, "quit")

func play():
	var _success = get_tree().change_scene("res://scenes/game.tscn")

func quit():
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("ui_accept"):
		play()
