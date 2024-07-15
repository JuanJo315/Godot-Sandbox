extends CharacterBody2D

@export var speed = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var navigation_agent_2d = $NavigationAgent2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# We get the size of the screen like this
	# screen_size = get_viewport_rect().size
	call_deferred("actor_setup")
	# pass # 

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	navigation_agent_2d.set_target_position(get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector. (0, 0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		# To avoid the player from moving faster diagonally we normalize 
		# the velocity meaning we set the length to 1 
		velocity= velocity.normalized() * speed
		
		#Now we check if the player moves to animate the sprites 
		$AnimatedSprite2D.play()
	else: 
		$AnimatedSprite2D.stop()
	
	# Update the player's position 
	# position += velocity * delta
	# And to prevent it from leaving the screen we use clamp()
	# position = position.clamp(Vector2.ZERO, screen_size)
	
	# Now we change the animation based on the direction the player moves 
	if velocity.x != 0: 
		# walk sprite looks to the right so when player moves to the left 
		# we flip the sprite using flip horizontally
		$AnimatedSprite2D.animation = "walk right"
		# $AnimatedSprite2D.flip_v = false
		
		# This boolean assignment is a shorthand for programming 
		$AnimatedSprite2D.flip_h = velocity.x < 0
		# It has the same purpose as the next code 
		# if velocity.x < 0:
			# $AnimatedSprite2D.flip_h = true
		# else:
			# $AnimatedSprite2D.flip_h = false
	elif velocity.y > 0:
		# Now for the down animation, since we have the upwards direction, 
		# We flip vertically to make it looks like it goes down 
		$AnimatedSprite2D.animation = "walk down"
	else:
		$AnimatedSprite2D.animation = "walk up"
		
		
		# $AnimatedSprite2D.flip_v = velocity.y > 0
		# Same for this shorthand method  
		# if velocity.y > 0:
			# $AnimatedSprite2D.flip_v = true
		# else:
			# $AnimatedSprite2D.flip_v = false
	# pass
	velocity = move_and_collide(velocity * delta)

"""
func _physics_process(_delta) -> void: 
	var mouse_position = get_global_mouse_position()
	navigation_agent_2d.target_position = mouse_position
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	if navigation_agent_2d.avoidance_enabled: 
		navigation_agent_2d.set_velocity_forced(new_velocity)
	else: 
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
"""

