extends CanvasLayer

onready var _bus := AudioServer.get_bus_index("Master")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/demo_tung.tscn")


func _ready():
	$Volume.connect("value_changed", self, "set_volume")

func set_volume(value: float):
	AudioServer.set_bus_volume_db(0, linear2db(value))
