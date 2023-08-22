extends Control

var money = 0
var day = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$NextDayButton.hide()

func _on_boat_body_entered(body):
	$NextDayButton.show()
	#Open shop

func _on_valuable_collected(worth):
	money += worth
	$Money.text = "%s$" % money


func _on_next_day_button_pressed():
	$NextDayButton.hide()
	day += 1
	$Days.text = "Day %s" % day
	pass # Replace with function body.
