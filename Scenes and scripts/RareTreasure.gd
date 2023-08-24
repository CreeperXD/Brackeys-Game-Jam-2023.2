extends Area2D

signal collected

func _ready():
	rotation = randf_range(-PI, PI)

func _on_body_entered(body):
	collected.emit()
	queue_free()
