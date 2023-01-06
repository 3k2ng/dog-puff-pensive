extends HBoxContainer

const BONE_LIFE: PackedScene = preload("res://objects/ui/bone_life.tscn")

func _process(delta: float) -> void:
	if PlayerInfo.current_health >= 0:
		if len(get_children()) == PlayerInfo.current_health:
			return
		for child in get_children():
			child.queue_free()
		for i in range(PlayerInfo.current_health):
			var new_bone = BONE_LIFE.instance()
			add_child(new_bone)
