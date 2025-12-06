extends Keyword
class_name teleport

func create(newMagic: Magic):
	newMagic.global_position = newMagic.get_global_mouse_position()

func get_keyword_name():
	return "Teleport"
