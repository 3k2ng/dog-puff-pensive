extends Area2D

var velocity
var moveSpeed = 100 
var dodgeSpeed = moveSpeed*5
# get the size of the viewing port to prevent the character from leaving the screen 
var screenSize  

func _ready():
	screenSize = get_viewport_rect().size


# in the process function we'll define eight directional movement
# controls will be wasd and left stick of a controller
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1 
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	# this is fo the dodge roll movement option
	# checks to see if the player is in motion and has pressed the correct input
	if velocity.length() > 0 and Input.is_action_just_pressed("dodge_roll"):
		# if true then velocity calculated with the speed of the dodge instead of normal move speed 
		velocity = velocity.normalized() * dodgeSpeed
	else:
		velocity = velocity.normalized() * moveSpeed
	#Now that we define movement based on input we want to have the object move 
	# at the speed previously defined
	# by using normalized() method you ensure that the speed in 
	# any direction is the moveSpeed defined
	
	# need to 
	# update the position of the object based on velocity and time since last frame
	position += velocity * delta 
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)

	
