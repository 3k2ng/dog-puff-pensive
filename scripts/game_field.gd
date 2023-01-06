extends Node

func _ready() -> void:
	SignalBus.connect("spawn_object", self, "add_child")
