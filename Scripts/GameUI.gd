extends Control

@export var slime_label : Label
@export var wood_label : Label
@export var metal_label : Label

func _process(_delta):
	slime_label.text = "Slime: " + "%d" % GameManager.slime
	wood_label.text = "Wood: " + "%d" % GameManager.wood
	metal_label.text = "Metal: " + "%d" % GameManager.metal
