extends Area2D

var enemy_attacked

func _ready():
	self.connect("body_entered", self, "if_body_entered")
	



func if_body_entered(body: Node):
	if body.is_in_group("enemy"):
		print("enemy is hit")
		body.hurt(Vector2.RIGHT.rotated(rotation), 1)
	

func melee_input():
	if Input.get_connected_joypads().size() > 0:
		rotation = Vector2.RIGHT.angle_to(Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized())
	else: 
		self.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("melee_attack"):
		$BoneAnimation.play("bone_melee")
