extends Spatial

onready var INTERFACE_MENU_LOADING = get_node("Interface_menu_loading")
onready var INTERFACE_MENU_MAIN = get_node("Interface_menu_main")
onready var INTERFACE_MENU_MISSION = get_node("Interface_menu_mission")
onready var INTERFACE_MENU_OPTION = get_node("Interface_menu_option")
onready var INTERFACE_MENU_OPTION_GAMEPLAY = get_node("Interface_menu_option_gameplay")
onready var INTERFACE_MENU_OPTION_GRAPHIC = get_node("Interface_menu_option_graphic")
onready var INTERFACE_MENU_OPTION_SOUND = get_node("Interface_menu_option_sound")
onready var INTERFACE_MENU_OPTION_VISUAL = get_node("Interface_menu_option_visual")
onready var INTERFACE_MENU_PAUSE = get_node("Interface_menu_pause")

onready var SAVE_LOAD = get_node("Save_load")

var STATE = ""

var load_scene
var load_instance

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	STATE = "MENU_MAIN"
	
	INTERFACE_MENU_LOADING.visible = false
	INTERFACE_MENU_MAIN.visible = true
	INTERFACE_MENU_MISSION.visible = false
	INTERFACE_MENU_OPTION.visible = false
	INTERFACE_MENU_OPTION_GAMEPLAY.visible = false
	INTERFACE_MENU_OPTION_GRAPHIC.visible = false
	INTERFACE_MENU_OPTION_SOUND.visible = false
	INTERFACE_MENU_OPTION_VISUAL.visible = false
	INTERFACE_MENU_PAUSE.visible = false

func _process(delta):
	reset()
	
	if (Input.is_action_just_pressed("esc") and STATE == "IN_GAME"):
		STATE = "MENU_PAUSE"
		INTERFACE_MENU_PAUSE.visible = true
	elif(Input.is_action_just_pressed("esc") and STATE == "MENU_PAUSE"):
		STATE = "IN_GAME"
		INTERFACE_MENU_PAUSE.visible = false
	
	if (STATE == "IN_GAME"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if (STATE == "MENU_PAUSE"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		INTERFACE_MENU_PAUSE.visible = true
		get_tree().paused = true
	
	if (STATE == "MENU_MAIN"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		INTERFACE_MENU_MAIN.visible = true

func reset():
	get_tree().paused = false

func load_scene(load_scene, load_name):
	load_scene = load(load_scene)
	load_instance = load_scene.instance()
	load_instance.name = load_name
	add_child(load_instance)

func remove_scene(remove_name):
	var node_to_remove = get_node(remove_name)
	node_to_remove.queue_free()
