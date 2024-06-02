extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.playerAlive:
		Global.gameStarted = false
		get_tree().change_scene_to_file("res://scenes/Endmenu.tscn")

func _on_change_level_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
