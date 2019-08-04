extends Area2D

enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;
export(float) var direction;
export(float) var inchdir = 1;
var true_knockback = 0;

onready var host = get_parent().get_parent().get_parent();

var calc_direction = true;

func _ready():
	true_knockback = knockback;

func _physics_process(delta):
	if(calc_direction):
		direction = global_rotation_degrees * get_parent().scale.x;
		calc_direction = false;