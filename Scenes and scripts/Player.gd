extends CharacterBody2D

'''
Initial variables serve to reset the current variables in each game
Current variables is what the upgrades will modify
Remaining variables changes in a dive session
'''
@export var initial_diving_speed = 500
var current_diving_speed
@export var initial_max_gas = 300 #litres
var current_max_gas
var remaining_gas
@export var initial_gas_consume_rate = 1 #litres per second
var current_gas_consume_rate
@export var initial_hypothermia_resistance = 1000
var current_hypothermia_resistance
var remaining_hypothermia_resistance
var paused = true

signal gas_consumed(max_gas, remaining_gas)
signal hypothermia_resistance_lost(max_heat, remaining_heat)
signal dead(cause)
signal touched_rope(max_gas, gas_consume_rate, hypothermia_resistance, diving_speed)

func _process(delta):
	if not paused:
		remaining_gas -= current_gas_consume_rate * delta
		gas_consumed.emit(current_max_gas, remaining_gas)
		
		#For every 1000 units below sea, resistance is used at a rate of 1 per second
		remaining_hypothermia_resistance -= position.y / 1000 * delta
		hypothermia_resistance_lost.emit(current_hypothermia_resistance, remaining_hypothermia_resistance)
		
		#💀💀💀💀💀
		if remaining_gas < 0:
			paused = true
			dead.emit("asphyxiation")
		if remaining_hypothermia_resistance < 0:
			paused = true
			dead.emit("hypothermia")

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
		
		if direction != Vector2.ZERO:
			#Normalise the direction so moving diagonally is as fast as moving vertically or horizontally
			direction = direction.normalized()
			$AnimatedSprite2D.speed_scale = 2
		else:
			$AnimatedSprite2D.speed_scale = 1
		#Actually moving
		velocity.x = direction.x * current_diving_speed
		velocity.y = direction.y * current_diving_speed
		
		#Flip player around horizontally based on their horizontal direction
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x > 0
		
		move_and_slide()

func _on_rope_body_entered(body):
	#Open shop and pause player, or win if "rare treasure" acquired
	paused = true
	touched_rope.emit(current_max_gas, current_gas_consume_rate, current_hypothermia_resistance, current_diving_speed)

func _on_user_interface_next_day_button_pressed(new_max_gas, new_gas_consume_rate, new_hypothermia_resistance, new_diving_speed):
	#Resume from shop, modifying the stats
	current_max_gas = new_max_gas
	current_gas_consume_rate = new_gas_consume_rate
	current_hypothermia_resistance = new_hypothermia_resistance
	current_diving_speed = new_diving_speed
	start_dive()

func _on_user_interface_game_started():
	current_diving_speed = initial_diving_speed
	current_max_gas = initial_max_gas
	current_gas_consume_rate = initial_gas_consume_rate
	current_hypothermia_resistance = initial_hypothermia_resistance
	start_dive()

func start_dive():
	#Replenish the remaining variables each day, then start with the player moved away from the boat
	remaining_gas = current_max_gas
	remaining_hypothermia_resistance = current_hypothermia_resistance
	paused = false
	position = Vector2(0, 500)
