extends Spatial

onready var INTERFACE_MENU_MAIN = get_node("Interface_menu_main")
onready var INTERFACE_MENU_MISSION_OBJECT = get_node("Interface_menu_mission_object")
onready var INTERFACE_MENU_MISSION_OBJECTIVE = get_node("Interface_menu_mission_objective")
onready var INTERFACE_MENU_MISSION_POWER = get_node("Interface_menu_mission_power")
onready var INTERFACE_MENU_MISSION_RUNE = get_node("Interface_menu_mission_rune")
onready var INTERFACE_MENU_NO = get_node("Interface_menu_no")
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

var map_actual

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	STATE = "MENU_MAIN"
	
	INTERFACE_MENU_MAIN.visible = true
	INTERFACE_MENU_MISSION_OBJECT.visible = false
	INTERFACE_MENU_MISSION_OBJECTIVE.visible = false
	INTERFACE_MENU_MISSION_POWER.visible = false
	INTERFACE_MENU_MISSION_RUNE.visible = false
	INTERFACE_MENU_NO.visible = false
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
	test_change_map()

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

func load_scene_map(load_scene, load_name, node_name):
	load_scene = load(load_scene)
	load_instance = load_scene.instance()
	load_instance.name = load_name
	map_actual = node_name
	add_child(load_instance)

func load_scene_player(load_scene, load_name):
	load_scene = load(load_scene)
	load_instance = load_scene.instance()
	load_instance.name = load_name
	add_child(load_instance)

func remove_scene(remove_name):
	var node_to_remove = get_node(remove_name)
	node_to_remove.free()

func change_interface(interface_from, interface_to, mouse_control, state, pause):
	interface_from.visible = false
	interface_to.visible = true
	Input.set_mouse_mode(mouse_control)
	STATE = state
	get_tree().paused = pause

func remove_visible_interface(interface):
	interface.visible = false

##########################################################################
func test_change_map():
	if (Input.is_action_just_pressed("p")):
		remove_scene("Map_actual")
		
		if (map_actual == "Map_01"):
			load_scene_map("res://Map/Map_02.tscn", "Map_actual", "Map_02")
		else:
			load_scene_map("res://Map/Map_01.tscn", "Map_actual", "Map_01")
		
		var map_actual = get_node("Map_actual")
		var initial_player_position = map_actual.get_node("Position_player_spawn")
		var player_actual = get_node("Player_actual")
		player_actual.global_transform.origin = initial_player_position.global_transform.origin
