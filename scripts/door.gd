extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_detector_body_entered(body):
	body = Global.playerBody
	if Input.is_action_just_pressed("opening_door") == true:
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
