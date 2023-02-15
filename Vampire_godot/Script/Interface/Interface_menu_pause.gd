extends Control

onready var main_node = get_parent()

func _ready():
	get_tree().paused = false

func _on_Button_continue_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)

func _on_Button_save_pressed():
#	main_node.get_node("Save_load").save_file(0)
	pass

func _on_Button_load_pressed():
#	main_node.get_node("Save_load").load_file(0)
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED, Input.MOUSE_MODE_VISIBLE, "MENU_LOAD_GAME_PROFIL_SELECTED", true)
	pass

func _on_Button_exit_pressed():
#	main_node.STATE = "MENU_MAIN"
	main_node.get_node("Map_actual").queue_free()
	main_node.get_node("Player_actual").queue_free()
#	main_node.INTERFACE_MENU_PAUSE.visible = false
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)

func _on_Button_option_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_GAMEPLAY, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_GAMEPLAY", true)
