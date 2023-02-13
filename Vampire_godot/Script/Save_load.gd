extends Spatial

onready var main_node = get_parent()

func _ready():
#	print(main_node)
	pass

func save_file(profil):
	var score_file = "res://Save.save"
	var file = File.new()
	file.open(score_file, File.WRITE)
	var dict = {
		"Map_actual" : main_node.get_node("Map_actual"),
		"Player_position" : main_node.get_node("Player_actual").global_transform.origin,
	}
	file.store_var(dict)
	file.close()

func load_file(profil):
	var score_file = "Save.save"
	var file = File.new()
	if file.file_exists(score_file):
		file.open(score_file, File.READ)
		var value = file.get_var()
		file.close()
#		print(value.get("Map_actual"))
		var test = value.get("Map_actual")
		print(test)
		print(value.get("Player_position"))
