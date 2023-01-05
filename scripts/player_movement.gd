extends KinematicBody2D

var velocity = Vector2()
export var move_speed = 100 

func _ready():
	pass
	

func _physics_process(_delta):
	
	$MeleeArea.melee_input()
	velocity = move_and_slide(Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * move_speed)
	if Input.is_action_just_pressed("dodge_roll"):
		if velocity.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		$PlayerAnimation.play("dodge_roll")

	elif velocity.x > 0 and velocity.y == 0 and $PlayerAnimation.current_animation != "dodge_roll":
		$Sprite.flip_h = false
		$PlayerAnimation.play("dog_run")
	elif velocity.x < 0 and velocity.y == 0 and $PlayerAnimation.current_animation != "dodge_roll":
		$Sprite.flip_h = true
		$PlayerAnimation.play("dog_run")
	elif velocity == Vector2.ZERO and $PlayerAnimation.current_animation != "dodge_roll":
		$PlayerAnimation.play("idle") 




