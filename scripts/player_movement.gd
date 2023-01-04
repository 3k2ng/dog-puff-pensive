extends KinematicBody2D

var velocity = Vector2()
export var move_speed = 100 

func _ready():
	pass
	

func _physics_process(delta):
	
	if Input.is_action_pressed("dodge_roll"):
		
		$AnimationPlayer.play("dodge_roll")
		
	velocity = move_and_slide(Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * move_speed)
	
	 
	
