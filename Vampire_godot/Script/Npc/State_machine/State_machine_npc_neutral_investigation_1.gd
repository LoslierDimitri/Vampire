extends Spatial

onready var state_node = get_parent()

onready var TIMER_SMALL_VISIBLE = get_node("Timer_small_time_visible")
onready var TIMER_SMALL_NO_VISIBLE = get_node("Timer_small_time_no_visible")

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var is_player_visible = false
var is_timer_done = false

var look_at_target
var pathfinding_target

var target_player
var target_player_last_position
var target_no

var node_target_player
var node_target_dead
var node_target_npc

func get_data():
	player_list = state_node.player_list
	dead_list = state_node.dead_list
	npc_list = state_node.npc_list
	sound_list = state_node.sound_list
	
	target_player = state_node.player_node
	target_player_last_position = state_node.player_node_last_position
	target_no = state_node.parent_node
	
	node_target_dead = state_node.target_dead

func set_data():
	if (look_at_target != null):
		state_node.target_look_at = look_at_target
	if (pathfinding_target != null):
		state_node.target_pathfinding = pathfinding_target

##########################################################################
func calcul():
	get_data()
	
	#player detection
	"""
	si player visible apres court temps
		change state to combat
	"""
	look_at_target = node_target_dead
	pathfinding_target = node_target_dead
	if (state_node.is_node_visible(player_list, "player") == true):
		is_player_visible = false
		is_timer_done = false
		state_node.change_state("combat")
	
	set_data()

func _on_Timer_small_time_visible_timeout():
	is_timer_done = true
func _on_Timer_small_time_no_visible_timeout():
	is_timer_done = true
