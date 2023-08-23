extends Control

var money = 696969
var day = 1
var new_initial_gas_amount
var new_gas_consume_rate
var new_hypothermia_death_resistance
var new_diving_speed
var movement_penalty = 10
var gas_tank_price = 500
var rebreather_price = 5000
var heated_suit_price = 5000

signal next_day_button_pressed(new_initial_gas_amount, new_gas_consume_rate, new_hypothermia_death_resistance, new_diving_speed)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shop/AdditionalTanks/AdditionalTanksPurchase.text = "%s$" % gas_tank_price
	$Shop/Rebreather/RebreatherPurchase.text = "%s$" % rebreather_price
	$Shop/HeatedSuit/HeatedSuitPurchase.text = "%s$" % heated_suit_price
	$Shop.hide()

func _on_valuable_collected(worth):
	money += worth
	$Money.text = "%s$" % money

func _on_next_day_button_pressed():
	#Close shop
	$Shop.hide()
	$GasBar.show()
	day += 1
	$Days.text = "Day %s" % day
	next_day_button_pressed.emit(new_initial_gas_amount, new_gas_consume_rate, new_hypothermia_death_resistance, new_diving_speed)

func _on_player_gas_consumed(initial_amount, current_amount):
	#Change the gas bar length based on the gas consumed
	$GasBar/Fill.size.y = $GasBar.size.y * current_amount / initial_amount

func _on_player_touched_boat(initial_gas_amount, gas_consume_rate, hypothermia_death_resistance, diving_speed):
	#Open shop
	$Shop.show()
	$GasBar.hide()
	
	new_initial_gas_amount = initial_gas_amount
	new_gas_consume_rate = gas_consume_rate
	new_hypothermia_death_resistance = hypothermia_death_resistance
	new_diving_speed = diving_speed

func _on_additional_tanks_purchase_pressed():
	if has_enough_money(gas_tank_price):
		new_initial_gas_amount += 20
		new_diving_speed -= movement_penalty
		gas_tank_price += 100
		$Shop/AdditionalTanks/AdditionalTanksPurchase.text = "%s$" % gas_tank_price

func _on_rebreather_purchase_pressed():
	if has_enough_money(rebreather_price):
		new_gas_consume_rate = 0.5
		$Shop/Rebreather/RebreatherPurchase.text = "Purchased"
		$Shop/Rebreather/RebreatherPurchase.disabled = true

func _on_heated_suit_purchase_pressed():
	if has_enough_money(heated_suit_price):
		new_hypothermia_death_resistance = 5000
		$Shop/HeatedSuit/HeatedSuitPurchase.text = "Purchased"
		$Shop/HeatedSuit/HeatedSuitPurchase.disabled = true

func has_enough_money(price):
	if money >= price:
		money -= price
		$Money.text = "%s$" % money
		#Kaching
		return true
	else:
		#Nope
		return false
