tool
extends StaticBody2D

export var activated: bool
export var id: String

func _process(_delta: float) -> void:
	if activated:
		collision_layer = 0
		collision_mask = 0
		$Sprite.frame = 1
	else:
		collision_layer = 7
		collision_mask = 7
		$Sprite.frame = 0

func activate() -> void:
	activated = not activated
