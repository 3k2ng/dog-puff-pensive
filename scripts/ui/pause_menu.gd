extends CanvasLayer

func _ready():
	visible = false

	var _success = $Restart.connect("button_down", self, "restart")
	_success = $Quit.connect("button_down", self, "quit")


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("pause"):
		toggle_pause()
	if event.is_action_pressed("restart"):
		restart()

func toggle_pause():
	var tree = get_tree()
	tree.paused = !tree.paused
	visible = tree.paused
	
	if visible:
		$Restart.grab_focus();

func restart():
	get_tree().paused = false
	var _success = get_tree().change_scene("res://scenes/game.tscn")

func quit():
	get_tree().quit()
