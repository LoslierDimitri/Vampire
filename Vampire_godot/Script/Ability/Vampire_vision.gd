extends Spatial

onready var MATERIAL_VAMPIRE_VISION_01 = load("res://Material/Npc_foe_01.tres")

var material_list = []

func _ready():
	MATERIAL_VAMPIRE_VISION_01.flags_no_depth_test = false
	
	material_list.append(MATERIAL_VAMPIRE_VISION_01)

func vision(display):
	if (display == false):
		for node in material_list:
			node.flags_no_depth_test = false
	else:
		for node in material_list:
			node.flags_no_depth_test = true
