extends Spatial

onready var MATERIAL_VAMPIRE_VISION_01 = load("res://Material/Npc_foe_01.tres")

func _ready():
	MATERIAL_VAMPIRE_VISION_01.flags_no_depth_test = false

func vision(display):
	if (display == false):
		MATERIAL_VAMPIRE_VISION_01.flags_no_depth_test = true
	else:
		MATERIAL_VAMPIRE_VISION_01.flags_no_depth_test = false
