extends Control

onready var main_node = get_tree().root.get_node("Main")
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
	
	LOG.text = text_to_print
