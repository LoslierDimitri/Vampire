extends Spatial

onready var state_node = get_parent()

onready var TIMER_SMALL = get_node("Timer_small_time")

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
	
	node_target_npc = state_node.target_npc
	
#	node_target_dead = state_node.parent_node.target_dead

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
	si joueur visible
		lance timer une fois
	si joueur non visible
		stop timer
	si joueur visible et timer fini
		investigation_1
	
	si corps au sol visible
		investigation_area
	
	si explosion proche
		investigation_area
	
	si npc non neutral
		investigation_area
	"""
	
	if (state_node.is_node_visible(player_list, "player") == true):
		if (is_player_visible == false):
			TIMER_SMALL.start()
			is_player_visible = true
	if (state_node.is_node_visible(player_list, "player") == false):
		TIMER_SMALL.stop()
		is_player_visible = false
	if (is_player_visible == true and is_timer_done == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_SMALL.stop()
		state_node.change_state("investigation_1")
	
	"""
	si dead visible
		target_pathfinding = target_dead
		target_look_at = target_dead
	"""
	if (state_node.is_node_visible(dead_list, "dead") == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_SMALL.stop()
		state_node.change_state("investigation_area")
	
	"""
	si npc non neutral visible
		target_pathfinding = target_npc
		target_look_at = target_npc
	"""
	if (state_node.is_node_visible(npc_list, "npc") == true):
		is_timer_done = false
		is_player_visible = false
		TIMER_SMALL.stop()
		look_at_target = node_target_npc
		pathfinding_target = node_target_npc
		state_node.change_state("investigation_area")
	
	set_data()

func _on_Timer_small_time_timeout():
	is_timer_done = true
