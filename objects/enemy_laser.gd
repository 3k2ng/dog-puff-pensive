extends Line2D

const SPLASH: PackedScene = preload("res://objects/splash.tscn")

const MAX_LENGTH: float = 512.0
const RAY_COUNT: int = 3
const RAY_WIDTH: float = 4.0

var direction: Vector2
var raycast_array: Array

var casted: bool

func _ready():
	add_point(Vector2.ZERO)
	raycast_array = []
	gen_raycast(direction, RAY_COUNT, RAY_WIDTH, get_tree().get_nodes_in_group("enemy"))
	casted = false
	$AnimationPlayer.play("fade")

func _process(delta: float) -> void:
	if $Lifetime.is_stopped():
		queue_free()
	if not casted and len(raycast_array) > 0:
		var collision = get_closest_collision()
		if not collision.empty():
			add_point(collision[1] - global_position)
			var new_splash = SPLASH.instance()
			new_splash.position = collision[1]
			SignalBus.emit_signal("spawn_object", new_splash)
			
			if collision[0].is_in_group("player"):
				collision[0].damage_taken(direction.normalized(), 1)
			casted = true

func gen_raycast(dir: Vector2, ray_count: int, ray_width: float, exception: Array = []) -> void:
	if raycast_array:
		for ray in raycast_array:
			ray.queue_free()
	raycast_array.clear()
	var right_vector = dir.rotated(PI / 2).normalized()
	for i in range(ray_count):
		var cur_width = ray_width * (i - ray_count / 2) / float(ray_count - 1)
		var new_ray = RayCast2D.new()
		new_ray.enabled = true
		new_ray.position = right_vector * cur_width
		new_ray.cast_to = dir.normalized() * MAX_LENGTH
		for body in exception:
			new_ray.add_exception(body)
		add_child(new_ray)
		raycast_array.append(new_ray)

func get_closest_collision() -> Dictionary:
	var closest: Dictionary = {}
	for ray in raycast_array:
		if ray.is_colliding():
			var cur_collider = ray.get_collider()
			var cur_collision_point = ray.get_collision_point()
			if closest.empty():
				closest[0] = cur_collider
				closest[1] = cur_collision_point
			elif closest[1].length() > cur_collision_point.length():
				closest[0] = cur_collider
				closest[1] = cur_collision_point
	return closest
