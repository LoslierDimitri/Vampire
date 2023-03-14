extends Spatial

onready var state_node = get_parent()

onready var TIMER_SMALL_VISIBLE = get_node("Timer_small_time_visible")
onready var TIMER_LONG_NO_VISIBLE = get_node("Timer_long_time_no_visible")

var player_list = []
var dead_list = []
var npc_list = []
var sound_list = []

var is_player_visible = false
var is_timer_done = false

var pathfinding_target
var look_at_target

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
	node_target_npc = state_node.target_npc

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
	si dead visible
		target_pathfinding = target_dead
		target_look_at = target_dead
	"""
	if (state_node.is_node_visible(dead_list, "dead") == true):
		look_at_target = node_target_dead
		pathfinding_target = node_target_dead
		TIMER_LONG_NO_VISIBLE.start()
	
	"""
	si npc non neutral visible
		target_pathfinding = target_npc
		target_look_at = target_npc
	"""
	if (state_node.is_node_visible(npc_list, "npc") == true):
		look_at_target = node_target_npc
		pathfinding_target = node_target_npc
	
	"""
	si player visible apres court temps
		change state to combat
	"""
	if (state_node.is_node_visible(player_list, "player") == true):
		if (is_player_visible == false):
			is_player_visible = true
			TIMER_SMALL_VISIBLE.start()
			TIMER_LONG_NO_VISIBLE.stop()
			look_at_target = target_player
	if (state_node.is_node_visible(player_list, "player") == false):
		if (is_player_visible == true):
			is_player_visible = false
			TIMER_SMALL_VISIBLE.stop()
			TIMER_LONG_NO_VISIBLE.start()
	if (is_player_visible == true and is_timer_done == true):
		is_player_visible = false
		is_timer_done = false
		TIMER_LONG_NO_VISIBLE.stop()
		TIMER_SMALL_VISIBLE.stop()
		look_at_target = target_no
		state_node.change_state("combat")
	
	"""
	si joueur non visible un long temps
		change state to neutral
	"""
#	if (state_node.is_node_visible(player_list, "player") == false):
#		if (is_player_visible == false):
#			TIMER_LONG_NO_VISIBLE.start()
#			TIMER_SMALL_VISIBLE.stop()
#	if (state_node.is_node_visible(player_list, "player") == false and is_timer_done == true):
#		is_player_visible = false
#		is_timer_done = false
#		TIMER_LONG_NO_VISIBLE.stop()
#		TIMER_SMALL_VISIBLE.stop()
#		state_node.NEUTRAL.TIMER_SMALL.start()
#		state_node.change_state("neutral")
	
	"""
	si npc non neutral visible
		target_pathfinding = target_npc
		target_look_at = target_npc
	"""
#	if (state_node.is_node_visible(npc_list, "npc") == true):
#		is_player_visible = false
#		is_timer_done = false
#		TIMER_LONG_NO_VISIBLE.stop()
#		TIMER_SMALL_VISIBLE.stop()
#		look_at_target = node_target_npc
#		pathfinding_target = node_target_npc
#		state_node.change_state("investigation_area")
	
	set_data()

func _on_Timer_small_time_timeout():
	is_timer_done = true
func _on_Timer_long_time_timeout():
	is_timer_done = true
