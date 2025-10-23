extends Control

@onready var inv: Inv = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	5
func _process(delta):
	var pressed = Input.is_action_just_pressed("Inv")
	if  Input.is_action_just_pressed("Inv") && !visible:
		open()
	elif pressed:
		close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func close():
	visible = false
	
func open():
	visible = true
