extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

onready var POSITION_LAUNCH = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch")
onready var POSITION_LAUNCH_TARGET = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch_target")
onready var RAYCAST = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Raycast")

onready var BLOOD_LANCE = load("res://Ability/Blood_lance.tscn")
onready var VAMPIRE_VISION = load("res://Ability/Vampire_vision.tscn")
onready var HYPNOSIS = load("res://Ability/Hypnosis.tscn")
onready var SHADOW_FORM = load("res://Ability/Shadow_form.tscn")
onready var BLOOD_LINK = load("res://Ability/Blood_link.tscn")

var blood_lance_instance
var blood_lance
var teleport_position
var can_teleport = false

var vampire_vision_instance
var vampire_vision
var vampire_vision_active = false

var hypnosis_instance
var hypnosis

var shadow_form_instance
var shadow_form
var shadow_form_active = false

var blood_link_instance
var blood_link

func _ready():
	blood_lance_instance = BLOOD_LANCE.instance()
	blood_lance_instance.name = "blood_lance"
	blood_lance_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(blood_lance_instance)
	blood_lance = get_node("blood_lance")
	
	vampire_vision_instance = VAMPIRE_VISION.instance()
	vampire_vision_instance.name = "vampire_vision"
	vampire_vision_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(vampire_vision_instance)
	vampire_vision = get_node("vampire_vision")
	
	hypnosis_instance = HYPNOSIS.instance()
	hypnosis_instance.name = "hypnosis"
	hypnosis_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(hypnosis_instance)
	hypnosis = get_node("hypnosis")
	
	shadow_form_instance = SHADOW_FORM.instance()
	shadow_form_instance.name = "shadow_form"
	shadow_form_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(shadow_form_instance)
	shadow_form = get_node("shadow_form")
	
	blood_link_instance = BLOOD_LINK.instance()
	blood_link_instance.name = "blood_link"
	blood_link_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(blood_link_instance)
	blood_link = get_node("blood_link")

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
#		print("action vampire_vision")
		
		if (vampire_vision_active == false):
			vampire_vision_active = true
			vampire_vision.vision(true)
		else:
			vampire_vision_active = false
			vampire_vision.vision(false)
	
	##########################################################################
	if (ability_name == "Hypnosis"):
#		print("action hypnosis")
		
		hypnosis.hypnosis(RAYCAST)
	
	##########################################################################
	if (ability_name == "Shadow_form"):
#		print("action shadow_form")
		
		if (shadow_form_active == false):
			shadow_form.shadow_form(true)
		else:
			shadow_form.shadow_form(false)
	
	##########################################################################
	if (ability_name == "Blood_link"):
#		print("action blood_link")
		
		blood_link.blood_link(RAYCAST)
