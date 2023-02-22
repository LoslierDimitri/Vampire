extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

var sword_list = []

export var damage_damage = 50
export var damage_type = "damage"
export var stun_damage = 1
export var stun_type = "stun"

func action(type):
	if (type == "damage"):
		for node in sword_list:
			node.take_damage(damage_damage, damage_type)
	if (type == "stun"):
		for node in sword_list:
			node.take_damage(stun_damage, stun_type)

func _on_Area_sword_normal_body_entered(body):
	if (body.is_in_group("Can_take_damage") == true):
		sword_list.append(body)
func _on_Area_sword_normal_body_exited(body):
	if (body.is_in_group("Can_take_damage") == true):
		sword_list.erase(body)
