extends Area2D

@export var minimum_worth := 500
@export var maximum_worth := 600
var worth

signal collected(worth)

# Called when the node enters the scene tree for the first time.
func _ready():
	worth = randi_range(minimum_worth, maximum_worth)
	
	rotation = randf_range(-PI, PI)
	
	var valuable_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(valuable_types[randi() % valuable_types.size()])

func _on_body_entered(body):
	collected.emit()
	queue_free()
