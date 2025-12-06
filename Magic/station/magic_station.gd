extends Node2D

@onready var ui: CanvasLayer = $UI
@onready var magic_1: Control = $UI/Magic1
@onready var magic_2: Control = $UI/Magic2
@onready var keywords_container: VBoxContainer = $UI/Layout/keywords
const KEYWORD_UI = preload("res://Magic/keywords/keyword_ui.tscn")

var player : PlayerMain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		return
	
func init_ui(body: PlayerMain):
	player = body
	ui.visible = true
	_create_children(magic_1.find_child("keyword_container"), player.magic1)
	_create_children(magic_2.find_child("keyword_container"), player.magic2)
	_create_keywords_container()
	
func _create_keywords_container():
	for child in keywords_container.get_children():
		child.queue_free()
		
	for i in player.keywords.size():
		var keyword = player.keywords[i]
		var instance : Keyword = keyword.instantiate()
		var size = KEYWORD_UI.instantiate()
		size.keyword = i
		size.get_child(0).text = instance.get_keyword_name()
		size.add1.connect(_add_1)
		size.add2.connect(_add_2)
		keywords_container.add_child(size)
	
func _add_1(keyword : int):
	var to_add = player.keywords[keyword]
	player.magic1.add_keyword(to_add)
	init_ui(player)
	
func _add_2(keyword : int):
	var to_add = player.keywords[keyword]
	player.magic2.add_keyword(to_add)
	init_ui(player)
	
func _create_children(keyword_container1, magic : Magic):
	for child in keyword_container1.get_children():
		child.queue_free()
		
	for i in magic.keywords.size():
		var keyword = magic.keywords[i]
		var instance : Keyword = keyword.instantiate()
		var size = KEYWORD_UI.instantiate()
		size.keyword = i
		size.magic = magic
		size.get_child(0).text = instance.get_keyword_name()
		size.remove.connect(_on_remove_keyword)
		keyword_container1.add_child(size)

func _on_remove_keyword(magic : Magic, keyword : int):
	magic.remove_keyword(keyword)
	init_ui(player)

func _on_interaction_body_entered(body: Node2D) -> void:
	if body.name != 'Player':
		return
	init_ui(body)


func _on_interaction_body_exited(body: Node2D) -> void:
	if body.name != 'Player':
		return
	player = null
	ui.visible = false
