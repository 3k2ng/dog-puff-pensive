extends KinematicBody2D
var max_health = 5 
var health
var velocity = Vector2()
export var move_speed = 100 
var is_hit
var hit_time 






func _ready():
	health = max_health
	is_hit = false
	hit_time = 0

func _physics_process(_delta):
	print(is_hit)
	if is_hit == true:
		velocity = move_and_slide(velocity)
		if hit_time == 5:
			is_hit = false
		hit_time = hit_time + 1
	else:
		
		hit_time = 0 
		$MeleeArea.melee_input()
		if $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			velocity = move_and_slide(Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * move_speed)
		else:
			velocity = move_and_slide(velocity.normalized() * (move_speed*1.25))
		if Input.is_action_just_pressed("dodge_roll"):
			if velocity.x < 0:
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false
			if velocity.y < 0:
				$PlayerAnimation.play("dodge_roll_up")
			elif velocity.y >= 0:
				$PlayerAnimation.play("dodge_roll")
			
		elif velocity.x > 0 and velocity.y >= 0 and $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			$Sprite.flip_h = false
			$PlayerAnimation.play("dog_run")
		elif velocity.x < 0 and velocity.y >= 0 and $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			$Sprite.flip_h = true
			$PlayerAnimation.play("dog_run")
		elif velocity.y > 0 and velocity.x == 0 and $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			$PlayerAnimation.play("dog_run")
		elif velocity == Vector2.ZERO and $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			$PlayerAnimation.play("idle") 
		elif velocity.y < 0 and $PlayerAnimation.current_animation != "dodge_roll" and $PlayerAnimation.current_animation != "dodge_roll_up":
			if velocity.x < 0:
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false
			$Sprite.flip_v = false
			$PlayerAnimation.play("dog_run_up")
		

func damage_taken(direction: Vector2, damage: int):
	health = health - damage 
	is_hit = true
	velocity = direction.normalized() * 250
	print("hit")



	
