extends Area2D

func _ready():
	pass

func _on_Flag_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player"):
		yield(get_tree().create_timer(0.6), "timeout")
	var _success = get_tree().change_scene("res://scenes/victory.tscn")
