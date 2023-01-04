extends Node

func _ready():
	SignalBus.connect("spawn_object", self, "add_child")
