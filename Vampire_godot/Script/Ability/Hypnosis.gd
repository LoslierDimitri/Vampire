extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")

onready var HYPNOSIS_MODEL = load("res://Ability/Hypnosis_model.tscn")

onready var TIMER = get_node("Timer")

export var timer = 5

func _ready():
	TIMER.set_time_wait(timer)

func hypnosis(raycast):
	pass
