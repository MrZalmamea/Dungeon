extends Control

@onready var inv: inventory = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	#update_Slots()
	close()

#func update_Slots():
	#for i in range(min(inv.item.size(), slots.size())):
		#slots[i].update(inv.item[i])

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
