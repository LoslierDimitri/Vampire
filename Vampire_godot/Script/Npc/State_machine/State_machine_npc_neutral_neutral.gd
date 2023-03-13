extends Spatial

onready var state_node = get_parent()

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var is_player_visible = false
var is_timer_done = false

var look_at_target
var target_player_last_position
var pathfinding_target

var node_target_player
var node_target_dead
var node_target_npc

func get_data():
	player_list = state_node.player_list
	dead_list = state_node.dead_list
	npc_list = state_node.npc_list
	sound_list = state_node.sound_list
	
#	node_target_dead = state_node.parent_node.target_dead

func set_data():
	if (look_at_target != null):
		state_node.target_look_at = look_at_target
	if (pathfinding_target != null):
		state_node.target_pathfinding = pathfinding_target

##########################################################################
func calcul():
	get_data()
	
	#dead detection
	"""
	si dead visible
		target_pathfinding = target_dead
		target_look_at = target_dead
	"""
	if (state_node.is_node_visible(dead_list, "dead") == true):
		state_node.change_state("investigation_1")
	
	set_data()
