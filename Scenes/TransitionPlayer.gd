extends AnimationPlayer

func _ready():
	play("start");

func deadend():
	play("deadend");

func reset():
	get_tree().reload_current_scene();