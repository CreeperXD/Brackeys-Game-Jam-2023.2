extends Node2D

@export var valueable_scene: PackedScene
var valueable_locations
@export var rare_treasure_scene: PackedScene
var rare_treasure_locations

func spawn_valuables():
	#Clear all the previous valueables first
	get_tree().call_group("Valueables", "queue_free")
	
	#Get the locations where valueables will spawn
	valueable_locations = $ValueableLocations.get_children()
	
	for location in valueable_locations:
		#Create a new instance of the valueable
		var valueable = valueable_scene.instantiate()
		valueable.position = location.position
		#Actually spawn the valueable
		add_child(valueable)
		
		#Connect the signal
		valueable.collected.connect($UserInterface._on_valuable_collected.bind())

func spawn_rare_treasure():
	#Clear the previous "rare treasure" first
	get_tree().call_group("RareTreasure", "queue_free")
	
	#Get the possible locations where "rare treasure" will spawn
	rare_treasure_locations = $RareTreasureLocations.get_children()
	
	#Create a new instance of the "rare treasure"
	var rare_treasure = rare_treasure_scene.instantiate()
	
	#Select a random location
	rare_treasure.position = rare_treasure_locations[randi_range(0, rare_treasure_locations.size() - 1)].position
	#Actually spawn the "rare treasure"
	add_child(rare_treasure)
	
	#Connect the signal
	rare_treasure.collected.connect($UserInterface._on_rare_treasure_collected.bind())

func _on_user_interface_game_started():
	spawn_valuables()
	spawn_rare_treasure()
