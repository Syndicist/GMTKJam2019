extends Node2D

var partNode;
var particle;
var hitNode;
var hitbox;

onready var dash_state = get_parent().get_parent().get_node("Movement_States").get_node("Dash");

### GENERAL FUNCTIONS ### 

func _ready():
	$hitbox.connect("area_entered",dash_state,"on_hit");

func instance_particle():
	partNode = preload("res://Game Objects/Actors/Player/Particles.tscn").instance();
	particle = partNode.get_child(0);
	partNode.scale = scale;
	get_parent().add_child(partNode);
	partNode.global_position = get_parent().global_position;
	$hitbox/CollisionPolygon2D.disabled = false;
	$hitbox.visible = true;
	$particleTimer.start(.2);
	$particleZTimer.start(.05);

func _on_particleTimer_timeout():
	if(is_instance_valid(partNode)):
		partNode.z_index = -1;
		particle.queue_free();
		partNode.queue_free()
	$hitbox.visible = false;
	$hitbox/CollisionPolygon2D.disabled = true;
	$particleTimer.stop();
	dash_state.attack = false;

func _on_particleZTimer_timeout():
	if(is_instance_valid(partNode)):
		partNode.z_index = 2;
