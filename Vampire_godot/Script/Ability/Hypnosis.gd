extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")

onready var HYPNOSIS_MODEL = load("res://Ability/Hypnosis_model.tscn")

#onready var TIMER = get_node("Timer")

export var range_use_hypnosis = 10
export var range_effective_hypnosis = 10
export var max_target_hypnosis = 2
export var timer = 5
export var timer_reset = 1

func _ready():
	pass
#	TIMER.set_wait_time(timer)

func hypnosis(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	if (raycast.get_collision_point().distance_to(raycast.global_transform.origin) < range_use_hypnosis):
		var hypnosis_model_instance = HYPNOSIS_MODEL.instance()
		hypnosis_model_instance.global_transform.origin = raycast.get_collision_point()
		hypnosis_model_instance.timer = timer
		hypnosis_model_instance.timer_reset = timer_reset
		hypnosis_model_instance.npc_max_hypnosis = max_target_hypnosis
		hypnosis_model_instance.range_effective_hypnosis = range_effective_hypnosis
		map_node.add_child(hypnosis_model_instance)
