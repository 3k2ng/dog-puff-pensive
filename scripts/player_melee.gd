extends Area2D

var enemy_attacked

func _ready():
	self.connect("body_entered", self, "if_body_entered")
	



func if_body_entered(body: Node):
	if Input.get_connected_joypads().size() > 0:
		pass
		# write attack code for controller later 
	else: 
		pass
	if body.is_in_group("enemy"):
		print("enemy is hit")
		$body.hurt()
	
func _Input(event):
	if Input.is_action_just_pressed("melee_attack"):
		$BoneAnimation.play("")


func melee_input():
	if Input.get_connected_joypads().size() > 0:
		pass
		# write attack code for controller later 
	else: 
		self.look_at(get_viewport().get_mouse_position())
		if Input.is_action_just_pressed("melee_attack"):
			$BoneAnimation.play("bone_melee")
