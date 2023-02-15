extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_exit_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED, main_node.INTERFACE_MENU_PAUSE, Input.MOUSE_MODE_VISIBLE, "MENU_PAUSE", true)

func _on_Button_load_1_pressed():
	main_node.get_node("Save_load").load_file(main_node.PROFIL)

func _on_Button_load_2_pressed():
	pass # Replace with function body.

func _on_Button_load_3_pressed():
	pass # Replace with function body.

func _on_Button_load_4_pressed():
	pass # Replace with function body.
