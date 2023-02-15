extends Spatial

onready var main_node = get_parent()

func _ready():
	pass

func save_file(profil):
	var Save_data = get_tree().get_nodes_in_group("Sava_data")
	var file_name = "res://Save_" + str(profil) + ".save"
	
	for save_data in Save_data:
		save_data.update()
		
		var file = File.new()
		file.open(file_name, File.WRITE)
		
		var dict = save_data.serialize()
		
		file.store_var(dict)
		file.close()
	
	load_file(profil)

func load_file(profil):
	var file_name = "Save_" + str(profil) + ".save"
	
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		var value = file.get_var()
		file.close()
		
#		print(value)
