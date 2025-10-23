extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var label: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	var item = slot.item
	if !item || !slot.amount:
		item_visual.visible = false
		label.text = ""
	else :
		item_visual.visible = true
		item_visual.texture = item.texture
		label.text = str(slot.amount)
