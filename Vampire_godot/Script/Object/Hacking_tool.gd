extends Spatial

onready var main_node = get_tree().root.get_node("Main")

onready var HACKING_TOOL = load("res://Object/Hacking_tool_model.tscn")

export var hacking_tool_launch_force = 15

func damage(position_launch, position_launch_target):
	var hacking_tool_instance = HACKING_TOOL.instance()
	hacking_tool_instance.global_transform.origin = position_launch.global_transform.origin
	hacking_tool_instance.apply_impulse(position_launch.global_transform.origin, (position_launch_target.global_transform.origin - position_launch.global_transform.origin) * hacking_tool_launch_force)
	main_node.add_child(hacking_tool_instance)
