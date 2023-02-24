extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

onready var POSITION_LAUNCH = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch")
onready var POSITION_LAUNCH_TARGET = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch_target")
onready var RAYCAST = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Raycast")

onready var GRENADE_EXPLOSIVE = load("res://Object/Grenade_explosive.tscn")
onready var GRENADE_STUN = load("res://Object/Grenade_stun.tscn")
onready var MINE_EXPLOSION = load("res://Object/Mine_explosive.tscn")
onready var MINE_STUN = load("res://Object/Mine_stun.tscn")
onready var GUN = load("res://Object/Gun.tscn")
onready var CROSSBOW_BOLT = load("res://Object/Crossbow_bolt.tscn")
onready var CROSSBOW_STUN = load("res://Object/Crossbow_stun.tscn")
onready var HACKING_TOOL = load("res://Object/Hacking_tool.tscn")

var grenade_explosive_instance
var grenade_explosive

var grenade_stun_instance
var grenade_stun

var mine_explosive_instance
var mine_explosive

var mine_stun_instance
var mine_stun

var gun_list = []
var gun_instance
var gun

var crossbow_bolt_instance
var crossbow_bolt

var crossbow_stun_instance
var crossbow_stun

var hacking_tool_instance
var hacking_tool

func _ready():
	grenade_explosive_instance = GRENADE_EXPLOSIVE.instance()
	grenade_explosive_instance.name = "grenade_explosive"
	grenade_explosive_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(grenade_explosive_instance)
	grenade_explosive = get_node("grenade_explosive")
	
	grenade_stun_instance = GRENADE_STUN.instance()
	grenade_stun_instance.name = "grenade_stun"
	grenade_stun_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(grenade_stun_instance)
	grenade_stun = get_node("grenade_stun")
	
	mine_explosive_instance = MINE_EXPLOSION.instance()
	mine_explosive_instance.name = "mine_explosive"
	mine_explosive_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(mine_explosive_instance)
	mine_explosive = get_node("mine_explosive")
	
	mine_stun_instance = MINE_STUN.instance()
	mine_stun_instance.name = "mine_stun"
	mine_stun_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(mine_stun_instance)
	mine_stun = get_node("mine_stun")
	
	gun_instance = GUN.instance()
	gun_instance.name = "gun"
	gun_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(gun_instance)
	gun = get_node("gun")
	
	crossbow_bolt_instance = CROSSBOW_BOLT.instance()
	crossbow_bolt_instance.name = "crossbow_bolt"
	crossbow_bolt_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(crossbow_bolt_instance)
	crossbow_bolt = get_node("crossbow_bolt")
	
	crossbow_stun_instance = CROSSBOW_STUN.instance()
	crossbow_stun_instance.name = "crossbow_stun"
	crossbow_stun_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(crossbow_stun_instance)
	crossbow_stun = get_node("crossbow_stun")
	
	hacking_tool_instance = HACKING_TOOL.instance()
	hacking_tool_instance.name = "hacking_tool"
	hacking_tool_instance.global_transform.origin = Vector3(0, -200, 0)
	add_child(hacking_tool_instance)
	hacking_tool = get_node("hacking_tool")

##########################################################################
func action(object_name):
	##########################################################################
	if (object_name == "None"):
#		print("action none")
		pass
	
	##########################################################################
	if (object_name == "Grenade_explosive"):
#		print("action grenade_explosion")
		grenade_explosive.damage(POSITION_LAUNCH, POSITION_LAUNCH_TARGET)
	
	##########################################################################
	if (object_name == "Grenade_stun"):
#		print("action Grenade_stun")
		grenade_stun.damage(POSITION_LAUNCH, POSITION_LAUNCH_TARGET)
	
	##########################################################################
	if (object_name == "Mine_explosive"):
#		print("action Mine_explosive")
		mine_explosive.damage(RAYCAST)
	
	##########################################################################
	if (object_name == "Mine_stun"):
#		print("action Mine_stun")
		mine_stun.damage(RAYCAST)
	
	##########################################################################
	if (object_name == "Gun"):
#		print("action Gun with list: ", gun_list)
		gun.damage(gun_list)
	
	##########################################################################
	if (object_name == "Crossbow_bolt"):
#		print("action Crossbow_bolt")
		crossbow_bolt.damage(RAYCAST)
	
	##########################################################################
	if (object_name == "Crossbow_stun"):
#		print("action Crossbow_stun")
		crossbow_stun.damage(RAYCAST)
	
	##########################################################################
	if (object_name == "Hacking_tool"):
#		print("action Hacking_tool")
		hacking_tool.damage(POSITION_LAUNCH, POSITION_LAUNCH_TARGET)

##########################################################################
func _on_Area_gun_body_entered(body):
	if (body.is_in_group("Can_take_damage") == true):
		gun_list.append(body)

func _on_Area_gun_body_exited(body):
	if (body.is_in_group("Can_take_damage") == true):
		gun_list.erase(body)
