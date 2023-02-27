extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

onready var POSITION_LAUNCH = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch")
onready var POSITION_LAUNCH_TARGET = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch_target")
onready var RAYCAST = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Raycast")

onready var BLOOD_LANCE = load("res://Ability/Blood_lance.tscn")

var blood_lance_instance
var blood_lance
var teleport_position
var can_teleport = false

func _ready():
	blood_lance_instance = BLOOD_LANCE.instance()
	blood_lance_instance.name = "blood_lance"
	blood_lance_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(blood_lance_instance)
	blood_lance = get_node("blood_lance")

##########################################################################
func action(ability_name):
	##########################################################################
	if (ability_name == "Blood_lance"):
#		print("action blood_lance")
		if (can_teleport == false):
			blood_lance.damage(RAYCAST)
		else:
			player_node.global_transform.origin = teleport_position
			can_teleport = false
	
	##########################################################################
	if (ability_name == "Vampire_vision"):
		print("action vampire_vision")
	
	##########################################################################
	if (ability_name == "Hypnosis"):
		print("action hypnosis")
	
	##########################################################################
	if (ability_name == "Shadow_form"):
		print("action shadow_form")
	
	##########################################################################
	if (ability_name == "Blood_link"):
		print("action blood_link")
	
