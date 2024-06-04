extends Node2D


func _on_area_2d_body_entered(body):
	if body is Player:
		print("Spieler erkannt")
		Global.is_general_chase = true
