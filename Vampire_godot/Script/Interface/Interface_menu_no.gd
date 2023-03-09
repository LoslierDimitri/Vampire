extends Control

onready var main_node = get_tree().root.get_node("Main")
var map_node
onready var player_node = main_node.get_node("Player_actual")

onready var LOG = get_node("LOG")

onready var TEST_WEAPON_NAME = get_node("TEST_weapon_name")

func _ready():
#	print(player_node)
	pass

func _process(delta):
	if (main_node.STATE == "MENU_NO"):
		print_log()
		
		TEST_WEAPON_NAME.text = player_node.object_or_ability_dictionary.get(player_node.object_or_ability)

func get_player():
	player_node = main_node.get_node("Player_actual")

func print_log():
	LOG.text = ""
	var text_to_print = ""
	
	text_to_print += "\nfps counter: " + str(Engine.get_frames_per_second())
	text_to_print += "\nobject or ability: " + player_node.object_or_ability_dictionary.get(player_node.object_or_ability)
	text_to_print += "\nlife point: " + str(player_node.life_point)
	
	map_node = main_node.get_node("Map_actual")
	var foe_state = map_node.get_node("Npc_foe").get_child(0).get_node("State_machine_npc_foe")
	text_to_print += "\nfoe state: " + str(foe_state)
	text_to_print += "\nfoe state: " + str(foe_state.state)
	text_to_print += "\nfoe state info: " + str(foe_state.text_to_print)
	text_to_print += "\nfoe state player_list: " + str(foe_state.player_list)
	text_to_print += "\nfoe state target_pathfinding: " + str(foe_state.target_pathfinding)
	text_to_print += "\nfoe state target_look_at: " + str(foe_state.target_look_at)
	
	LOG.text = text_to_print
