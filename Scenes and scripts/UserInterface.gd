extends Control

var money
var day
var new_max_gas
var new_gas_consume_rate
var new_hypothermia_resistance
var new_diving_speed
var movement_penalty = 5
var additional_tanks_penalty = 250
var initial_gas_tank_price = 500
var current_gas_tank_price
var rebreather_price = 5000
var heated_suit_price = 5000
var rare_treasure_collected = false

signal next_day_button_pressed(new_max_gas, new_gas_consume_rate, new_hypothermia_resistance, new_diving_speed)
signal game_started
signal game_ended

func _ready():
	#Start from main menu
	$Shop.hide()
	$Money.hide()
	$Days.hide()
	$GasBar.hide()
	$HypothermiaResistanceBar.hide()
	$RareTreasureIndicator.hide()
	$MainMenu.show()
	$Settings.hide()
	$Credits.hide()
	$Story.hide()
	$Lose.hide()
	$Win.hide()

func _on_valuable_collected(worth):
	money += worth
	$Money.text = "%s$" % money
	
func _on_rare_treasure_collected():
	rare_treasure_collected = true
	$RareTreasureIndicator.show()

func _on_next_day_button_pressed():
	#Close shop
	$Shop.hide()
	$GasBar.show()
	$HypothermiaResistanceBar.show()
	day += 1
	$Days.text = "Day %s" % day
	next_day_button_pressed.emit(new_max_gas, new_gas_consume_rate, new_hypothermia_resistance, new_diving_speed)

func _on_player_gas_consumed(max_gas, remaining_gas):
	#Change the gas bar length based on the gas consumed
	$GasBar/Fill.size.y = $GasBar.size.y * remaining_gas / max_gas

func _on_player_hypothermia_resistance_lost(max, remaining):
	#Change the hypothermia resistance bar length based on the said resistance lost
	$HypothermiaResistanceBar/Fill.size.y = $HypothermiaResistanceBar.size.y * remaining / max

func _on_player_dead(cause):
	#Lose
	$Money.hide()
	$Days.hide()
	$GasBar.hide()
	$HypothermiaResistanceBar.hide()
	$Lose/Message.text = "You died of %s. Better luck next time!" % cause
	$Lose.show()
	$MainMenuButton.show()
	game_ended.emit()

func _on_player_touched_rope(max_gas, gas_consume_rate, hypothermia_resistance, diving_speed):
	if rare_treasure_collected:
		#Win
		$Money.hide()
		$Days.hide()
		$GasBar.hide()
		$HypothermiaResistanceBar.hide()
		$Win/Message.text = "You found the \"rare treasure\" in %s days " % day
		$Win/Message.text += "with %s$ remaining! Well done!" % money
		$Win.show()
		$MainMenuButton.show()
		game_ended.emit()
	else:
		#Open shop
		$Shop.show()
		$GasBar.hide()
		$HypothermiaResistanceBar.hide()
		new_max_gas = max_gas
		new_gas_consume_rate = gas_consume_rate
		new_hypothermia_resistance = hypothermia_resistance
		new_diving_speed = diving_speed

func _on_additional_tanks_purchase_pressed():
	if has_enough_money(current_gas_tank_price):
		new_max_gas += 20
		#Technically this could go to negative speed, but should be too expsenive to get there
		new_diving_speed -= movement_penalty
		current_gas_tank_price += additional_tanks_penalty
		$Shop/AdditionalTanks/AdditionalTanksPurchase.text = "%s$" % current_gas_tank_price

func _on_rebreather_purchase_pressed():
	if has_enough_money(rebreather_price):
		new_gas_consume_rate = 0.5
		$Shop/Rebreather/RebreatherPurchase.text = "Purchased"
		$Shop/Rebreather/RebreatherPurchase.disabled = true

func _on_heated_suit_purchase_pressed():
	if has_enough_money(heated_suit_price):
		new_hypothermia_resistance = 5000
		$Shop/HeatedSuit/HeatedSuitPurchase.text = "Purchased"
		$Shop/HeatedSuit/HeatedSuitPurchase.disabled = true

func has_enough_money(price):
	#reminder to add sfx
	if money >= price:
		money -= price
		$Money.text = "%s$" % money
		#Kaching
		return true
	else:
		#Nope
		return false

func _on_main_menu_button_pressed():
	#This button is reused in many pages, so
	$RareTreasureIndicator.hide()
	$MainMenu.show()
	$Settings.hide()
	$Credits.hide()
	$Win.hide()
	$Lose.hide()
	$MainMenuButton.hide()

func _on_play_button_pressed():
	$MainMenu.hide()
	$Story.show()

func _on_settings_button_pressed():
	$MainMenu.hide()
	$Settings.show()
	$MainMenuButton.show()

func _on_credits_button_pressed():
	$MainMenu.hide()
	$Credits.show()
	$MainMenuButton.show()

func _on_dive_button_pressed():
	#Resetting stuff to start a game
	current_gas_tank_price = initial_gas_tank_price
	$Shop/AdditionalTanks/AdditionalTanksPurchase.text = "%s$" % current_gas_tank_price
	$Shop/Rebreather/RebreatherPurchase.text = "%s$" % rebreather_price
	$Shop/Rebreather/RebreatherPurchase.disabled = false
	$Shop/HeatedSuit/HeatedSuitPurchase.text = "%s$" % heated_suit_price
	$Shop/HeatedSuit/HeatedSuitPurchase.disabled = false
	rare_treasure_collected = false
	$RareTreasureIndicator.hide()
	$Story.hide()
	money = 696969
	day = 1
	$Money.text = "%s$" % money
	$Money.show()
	$Days.show()
	$GasBar.show()
	$HypothermiaResistanceBar.show()
	game_started.emit()
