extends Node

func _ready() -> void:
	var _success = SignalBus.connect("spawn_object", self, "add_child")
