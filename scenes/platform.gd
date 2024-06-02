extends AnimatableBody2D


func _process(delta): 	
	if Input.is_action_just_pressed("move_down"):
		$CollisionShape2D.set_disabled(true)
	if Input.is_action_just_pressed("jump"):
		$CollisionShape2D.set_disabled(false)
	

