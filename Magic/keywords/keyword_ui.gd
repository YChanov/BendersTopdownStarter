extends ReferenceRect
class_name MagicUI

signal remove(magic, keyword)
signal add1(keyword)
signal add2(keyword)

@onready var remove_btn: Button = $remove_btn
@onready var add_1: Button = $add_1
@onready var add_2: Button = $add_2

@export var keyword : int
@export var magic : Magic

func _on_button_pressed() -> void:
	remove.emit(magic, keyword)

func _ready() -> void:
	if !magic:
		remove_btn.visible = false
	else:
		add_1.visible = false
		add_2.visible = false

func _on_add_1_pressed() -> void:
	add1.emit(keyword)

func _on_add_2_pressed() -> void:
	add2.emit(keyword)
