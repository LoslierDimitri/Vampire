extends Control

onready var main_node = get_parent().get_parent()

func _ready():
	pass

func _on_Button_exit_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_MISSION_OBJECT, main_node.INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)

func _on_Button_object_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_MISSION_OBJECT, main_node.INTERFACE_MENU_MISSION_OBJECT, Input.MOUSE_MODE_VISIBLE, "MENU_MISSION", true)

func _on_Button_objective_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_MISSION_OBJECT, main_node.INTERFACE_MENU_MISSION_OBJECTIVE, Input.MOUSE_MODE_VISIBLE, "MENU_MISSION", true)

func _on_Button_power_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_MISSION_OBJECT, main_node.INTERFACE_MENU_MISSION_POWER, Input.MOUSE_MODE_VISIBLE, "MENU_MISSION", true)

func _on_Button_rune_pressed():
	remove_interface()
	main_node.change_interface(main_node.INTERFACE_MENU_MISSION_OBJECT, main_node.INTERFACE_MENU_MISSION_RUNE, Input.MOUSE_MODE_VISIBLE, "MENU_MISSION", true)

func remove_interface():
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_MISSION_OBJECT)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_MISSION_OBJECTIVE)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_MISSION_POWER)
	main_node.remove_visible_interface(main_node.INTERFACE_MENU_MISSION_RUNE)
