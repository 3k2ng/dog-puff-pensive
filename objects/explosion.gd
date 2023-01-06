extends Area2D

func _ready() -> void:
	self.connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage_taken((body.position - position).normalized(), 1)
	elif body.is_in_group("enemy"):
		body.hurt((body.position - position).normalized(), 1)

func _process(delta: float) -> void:
	if $Timer.is_stopped():
		queue_free()
