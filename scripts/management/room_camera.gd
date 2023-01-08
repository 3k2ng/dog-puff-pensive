extends Camera2D

const ROOM_WIDTH: float = 320.0
const ROOM_HEIGHT: float = 192.0

var target: KinematicBody2D
var current_room_coord: Vector2 = Vector2.ZERO

func get_player_as_target() -> void:
	var player_group: Array = get_tree().get_nodes_in_group("player")
	if len(player_group) > 0:
		target = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	if target:
		current_room_coord = Vector2(round(target.position.x / ROOM_WIDTH - 0.5), round(target.position.y / ROOM_HEIGHT - 0.5))
		var target_position = Vector2(current_room_coord.x * ROOM_WIDTH, current_room_coord.y * ROOM_HEIGHT) + Vector2.DOWN * 4
		position += (target_position - position) * delta * 4
	else:
		get_player_as_target()
