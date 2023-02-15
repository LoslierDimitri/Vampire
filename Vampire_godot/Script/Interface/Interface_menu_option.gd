extends Control

onready var main_node = get_parent().get_parent()

func _ready():
	pass

func _on_Button_option_gameplay_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_GAMEPLAY, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_GAMEPLAY", true)

func _on_Button_option_graphic_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_GRAPHIC, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_GRAPHIC", true)

func _on_Button_option_visual_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_VISUAL, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_VISUAL", true)

func _on_Button_option_sound_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_SOUND, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_SOUND", true)

func remove_interface():
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_OPTION_GAMEPLAY)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_OPTION_GRAPHIC)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_OPTION_VISUAL)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_OPTION_SOUND)

func _on_Button_exit_pressed():
	remove_interface()
	
	if (main_node.option_from == "MENU_MAIN"):
		main_node.change_interface(main_node.INTERFACE_MENU_OPTION_GAMEPLAY, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)
	elif (main_node.option_from == "MENU_PAUSE"):
		main_node.change_interface(main_node.INTERFACE_MENU_OPTION_GAMEPLAY, main_node.INTERFACE_MENU_PAUSE, Input.MOUSE_MODE_VISIBLE, "MENU_PAUSE", true)
