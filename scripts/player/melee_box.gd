extends Area2D

func _ready() -> void:
	var _success = self.connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage_taken(Vector2.RIGHT.rotated(rotation), 1)
	elif body.is_in_group("button"):
		body.activate()
