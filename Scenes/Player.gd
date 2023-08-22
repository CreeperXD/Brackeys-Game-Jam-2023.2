extends CharacterBody2D

@export var diving_speed = 500

'''
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
'''

func _physics_process(delta):
	'''
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	'''
	
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity.x = direction.x * diving_speed
	velocity.y = direction.y * diving_speed
	
	move_and_slide()
