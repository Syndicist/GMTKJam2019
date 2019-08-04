extends Line2D

export(NodePath) var targetPath;
var target;

var i = 0;
var j = 1;
export(int) var length = 50;
var switch = true;
var h = 0;
var arrPoints;
var randxk = 0;
var randxa = 0;
var randxb = 0;
var randya = 0;
var randyb = 0;
var ydamp = 0;
var just_stopped = false;

func _ready():
	target = get_node(targetPath);
	for i in 25:
		add_point(target.global_position);
	pass;

func _process(delta):
	global_position = Vector2(0,0);
	global_rotation = 0;
	
	if(get_parent().velocity != Vector2(0,0)):
		add_point(target.global_position);
		just_stopped = true;
		ydamp = 0;
	elif(get_point_count() > 0):
		set_point_position(get_point_count()-1, target.global_position);
		#if(just_stopped):
		#	randxk += get_parent().Direction;
		#	just_stopped = false;
		for i in get_point_count()-1:
			if(i%5 == 0):
				j += 1;
			var trandxk = randxk/5;
			set_point_position(i, 
			Vector2(
			get_point_position(i).x + randxa*sin((get_point_position(i).y-h)/randxb) + trandxk, 
			get_point_position(i).y + randya*sin((get_point_position(i).x-h)/randyb)));
			while(get_point_position(i).distance_to(get_point_position(i+1))>2):
				var mag = get_point_position(i) - get_point_position(i+1);
				var direction = mag.normalized();
				set_point_position(i, get_point_position(i) - direction * 1);
		h += .5;
		j = 0;
	if(get_point_position(0).distance_to(target.global_position) > 150):
		remove_point(0);
	if(get_point_position(0).distance_to(target.global_position) < 150):
		while(get_point_count() > 25):
			remove_point(0);



func _on_WindTimer_timeout():
	$WindxTimer.wait_time = rand_range(2,5);
	randxk = rand_range(-1,1);

func _on_WindyaTimer_timeout():
	$WindyaTimer.wait_time = rand_range(2,3);
	randya = rand_range(.1, 1.5);


func _on_WindybTimer_timeout():
	$WindybTimer.wait_time = rand_range(3,5);
	randyb = rand_range(10,20);

func _on_WindxaTimer_timeout():
	$WindxaTimer.wait_time = rand_range(2,3);
	randxa = rand_range(.1, 1.5);


func _on_WindxbTimer_timeout():
	$WindxbTimer.wait_time = rand_range(3,5);
	randxb = rand_range(10,20);

func _on_WindxTimer_timeout():
	pass # Replace with function body.

