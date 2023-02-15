extends Spatial

#onready var INTERFACE_MENU_LOADING = get_node("Interface_menu_loading")
onready var INTERFACE_MENU_MAIN = get_node("Interface_menu_main")
#onready var INTERFACE_MENU_MISSION = get_node("Interface_menu_mission")
onready var INTERFACE_MENU_MISSION_OBJECT = get_node("Interface_menu_mission_object")
onready var INTERFACE_MENU_MISSION_OBJECTIVE = get_node("Interface_menu_mission_objective")
onready var INTERFACE_MENU_MISSION_POWER = get_node("Interface_menu_mission_power")
onready var INTERFACE_MENU_MISSION_RUNE = get_node("Interface_menu_mission_rune")
onready var INTERFACE_MENU_NO = get_node("Interface_menu_no")
#onready var INTERFACE_MENU_OPTION = get_node("Interface_menu_option")
onready var INTERFACE_MENU_OPTION_GAMEPLAY = get_node("Interface_menu_option_gameplay")
onready var INTERFACE_MENU_OPTION_GRAPHIC = get_node("Interface_menu_option_graphic")
onready var INTERFACE_MENU_OPTION_SOUND = get_node("Interface_menu_option_sound")
onready var INTERFACE_MENU_OPTION_VISUAL = get_node("Interface_menu_option_visual")
onready var INTERFACE_MENU_PAUSE = get_node("Interface_menu_pause")
onready var INTERFACE_MENU_LOAD_GAME_PROFIL = get_node("Interface_menu_load_game_profil")
onready var INTERFACE_MENU_NEW_GAME_PROFIL = get_node("Interface_menu_new_game_profil")
onready var INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED = get_node("Interface_menu_load_game_profil_selected")

onready var SAVE_LOAD = get_node("Save_load")

var STATE = ""
var PROFIL

var load_scene
var load_instance

var option_from

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	STATE = "MENU_MAIN"
	
#	INTERFACE_MENU_LOADING.visible = false
	INTERFACE_MENU_MAIN.visible = true
#	INTERFACE_MENU_MISSION.visible = false
	INTERFACE_MENU_MISSION_OBJECT.visible = false
	INTERFACE_MENU_MISSION_OBJECTIVE.visible = false
	INTERFACE_MENU_MISSION_POWER.visible = false
	INTERFACE_MENU_MISSION_RUNE.visible = false
	INTERFACE_MENU_NO.visible = false
#	INTERFACE_MENU_OPTION.visible = false
	INTERFACE_MENU_OPTION_GAMEPLAY.visible = false
	INTERFACE_MENU_OPTION_GRAPHIC.visible = false
	INTERFACE_MENU_OPTION_SOUND.visible = false
	INTERFACE_MENU_OPTION_VISUAL.visible = false
	INTERFACE_MENU_PAUSE.visible = false
	INTERFACE_MENU_LOAD_GAME_PROFIL.visible = false
	INTERFACE_MENU_NEW_GAME_PROFIL.visible = false
	INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED.visible = false

func _process(delta):
	interface_control()

func interface_control():	
	if (STATE == "MENU_NO"):
		if (Input.is_action_just_pressed("esc")):
			change_interface(INTERFACE_MENU_NO, INTERFACE_MENU_PAUSE, Input.MOUSE_MODE_VISIBLE, "MENU_PAUSE", true)
		if (Input.is_action_just_pressed("tab")):
			change_interface(INTERFACE_MENU_NO, INTERFACE_MENU_MISSION_OBJECT, Input.MOUSE_MODE_VISIBLE, "MENU_MISSION", true)
	
	elif (STATE == "MENU_PAUSE"):
		option_from = "MENU_PAUSE"
		if (Input.is_action_just_pressed("esc")):
			change_interface(INTERFACE_MENU_PAUSE, INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)
	
	elif (STATE == "MENU_MAIN"):
		option_from = "MENU_MAIN"
	
	elif (STATE == "MENU_MISSION"):
		if (Input.is_action_just_pressed("tab")):
			remove_visible_interface(INTERFACE_MENU_MISSION_OBJECT)
			remove_visible_interface(INTERFACE_MENU_MISSION_OBJECTIVE)
			remove_visible_interface(INTERFACE_MENU_MISSION_POWER)
			remove_visible_interface(INTERFACE_MENU_MISSION_RUNE)
			change_interface(INTERFACE_MENU_MISSION_OBJECT, INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)

func load_scene(load_scene, load_name):
	load_scene = load(load_scene)
	load_instance = load_scene.instance()
	load_instance.name = load_name
	add_child(load_instance)

func remove_scene(remove_name):
	var node_to_remove = get_node(remove_name)
	node_to_remove.queue_free()

func change_interface(interface_from, interface_to, mouse_control, state, pause):
	interface_from.visible = false
	interface_to.visible = true
	Input.set_mouse_mode(mouse_control)
	STATE = state
	get_tree().paused = pause

#func remove_all_interface():
#	remove_visible_interface(INTERFACE_MENU_MISSION_OBJECT)
#	remove_visible_interface(INTERFACE_MENU_MISSION_OBJECTIVE)
#	remove_visible_interface(INTERFACE_MENU_MISSION_POWER)
#	remove_visible_interface(INTERFACE_MENU_MISSION_RUNE)
#	remove_visible_interface(INTERFACE_MENU_NO)
#	remove_visible_interface(INTERFACE_MENU_OPTION_GAMEPLAY)
#	remove_visible_interface(INTERFACE_MENU_OPTION_GRAPHIC)
#	remove_visible_interface(INTERFACE_MENU_OPTION_SOUND)
#	remove_visible_interface(INTERFACE_MENU_OPTION_VISUAL)
#	remove_visible_interface(INTERFACE_MENU_PAUSE)

func remove_visible_interface(interface):
	interface.visible = false
