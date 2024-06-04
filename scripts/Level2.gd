extends Node2D

var enemies = []
var defeated_enemies_count = 0

@onready var doorblockerlvl2 = $allenemiescollision/DoorblockerLvl2

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	defeated_enemies_count = 0
	
	enemies.append($enemy)
	enemies.append($Commander)
	
	for enemy in enemies:
		if enemy:
			enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))
	for Commander in enemies:
		if Commander:
			Commander.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.playerAlive:
		Global.gameStarted = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://scenes/Endmenu.tscn")

func _on_change_level_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/Level3.tscn")

func _on_enemy_defeated():
	defeated_enemies_count += 1
	
	if defeated_enemies_count >= enemies.size():
		doorblockerlvl2.disabled = true
