extends Node2D

@export var valueable_scene: PackedScene
var valueable_locations

func _ready():
	#Get the locations where valueables will spawn
	valueable_locations = $"Valueable locations".get_children()
	
	for location in valueable_locations:
		#Create a new instance of the valueable
		var valueable = valueable_scene.instantiate()
		valueable.position = location.position
		print(valueable.position)
		valueable.collected.connect($UserInterface._on_valuable_collected.bind())
