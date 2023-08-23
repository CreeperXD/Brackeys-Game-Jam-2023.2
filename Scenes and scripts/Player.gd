extends CharacterBody2D

@export var diving_speed = 500
@export var initial_gas_amount = 300 #litres
var current_gas_amount
var gas_consume_rate = 1 #litres per second
@export var hypothermia_death_resistance = 1000
var paused = false

signal gas_consumed(initial_amount, current_amount)
signal dead
signal touched_boat(initial_gas_amount, gas_consume_rate, hypothermia_death_resistance, diving_speed)

func _ready():
	current_gas_amount = initial_gas_amount

func _process(delta):
	if not paused:
		current_gas_amount -= gas_consume_rate * delta
		gas_consumed.emit(initial_gas_amount, current_gas_amount)
		
		#For every 1000 units below sea, resistance is used at a rate of 1 per second
		hypothermia_death_resistance -= position.y / 1000 * delta
		print("Resistance remaining: %s" % hypothermia_death_resistance) #replace with a snowflake effect
		
		if current_gas_amount < 0 or hypothermia_death_resistance < 0:
			dead.emit()

func _physics_process(delta):
	if not paused:
		var direction = Vector2.ZERO
		
		#Get direction from input
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		
		#Normalise the direction so moving diagonally is as fast as moving vertically or horizontally
		if direction != Vector2.ZERO:
			direction = direction.normalized()
		#Actually moving
		velocity.x = direction.x * diving_speed
		velocity.y = direction.y * diving_speed
		
		move_and_slide()

func _on_boat_body_entered(body):
	paused = true
	touched_boat.emit(initial_gas_amount, gas_consume_rate, hypothermia_death_resistance, diving_speed)

func _on_user_interface_next_day_button_pressed(new_initial_gas_amount, new_gas_consume_rate, new_hypothermia_death_resistance, new_diving_speed):
	initial_gas_amount = new_initial_gas_amount
	gas_consume_rate = new_gas_consume_rate
	hypothermia_death_resistance = new_hypothermia_death_resistance
	diving_speed = new_diving_speed
	
	current_gas_amount = initial_gas_amount
	
	paused = false
	
	#Move the player away from the boat
	position.y += 250
