extends Node2D

onready var host = get_parent().get_parent();
onready var idle =  get_parent().get_node("Idle");
onready var ledge_grab =  get_parent().get_node("Ledge_Grab");
onready var dash =  get_parent().get_node("Dash");

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("right") || host.mouse_r()) - int(Input.is_action_pressed("left") || host.mouse_l());
	return input_direction;

#sets direction and turns the player appropriately
func update_look_direction_and_scale(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		turn(direction);


func turn(direction):
	if(host.Direction != 0):
		host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1;
		host.get_node("Movement_States").scale.x = host.get_node("Movement_States").scale.x * -1;
	host.Direction = direction;

func get_dash_pressed():
	return (Input.is_action_pressed("dash") || Input.is_action_pressed("up") || Input.is_action_pressed("down") || Input.is_action_pressed("left") || Input.is_action_pressed("right"));

func get_dash_just_pressed():
	return (Input.is_action_just_pressed("dash") || Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down") || Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"));

func enter():
	pass;

func handleAnimation():
	pass;

func handleInput():
	pass;

func execute(delta):
	pass;

func exit(state):
	state.enter();
	pass;