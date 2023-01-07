extends Particles2D

var emitted: bool = false

func _ready() -> void:
	emitted = true
	emitting = true

func _process(_delta: float) -> void:
	if emitted and not emitting:
		queue_free()
