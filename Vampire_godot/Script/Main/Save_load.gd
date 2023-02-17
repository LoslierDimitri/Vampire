extends Spatial

onready var main_node = get_parent()

func _ready():
	pass

func save_file(profil):
	var Save_data = get_tree().get_nodes_in_group("Sava_data")
	var file_name = "res://Save_" + str(profil) + ".save"
	
	for save_data in Save_data:
		var file = File.new()
		file.open(file_name, File.WRITE)
		
		save_data.update()
		var dict = save_data.serialize()
		
		file.store_var(dict)
		file.close()
	
#	load_file(profil)

func load_file(profil):
	var file_name = "Save_" + str(profil) + ".save"
	var Load_data = get_tree().get_nodes_in_group("Load_data")
	
	for load_data in Load_data:
		load_data.deserialize(file_name)
		load_data.update()
	
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_LOAD_GAME_PROFIL)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED)
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)
	
#	var file = File.new()
#	if file.file_exists(file_name):
#		file.open(file_name, File.READ)
#
#		var value = file.get_var()
#		file.close()
		
#		print(value)
