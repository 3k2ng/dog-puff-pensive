extends KinematicBody2D

var velocity = Vector2()
export var move_speed = 100 

func _ready():
	pass
	

func _physics_process(_delta):
	if Input.is_action_just_pressed("dodge_roll"):
		$PlayerAnimation.play("dodge_roll")
	$MeleeArea.melee_input()
	velocity = move_and_slide(Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * move_speed)
	
	

	
	




