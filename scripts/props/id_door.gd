extends Node2D

export var id: String

func _process(_delta: float) -> void:
	for i in get_tree().get_nodes_in_group("id"):
		if i.id == id:
			if i.is_in_group("enemy"):
				if not i.get("dead"):
					return
			if i.is_in_group("button") and not i.activated:
				return
	queue_free()
