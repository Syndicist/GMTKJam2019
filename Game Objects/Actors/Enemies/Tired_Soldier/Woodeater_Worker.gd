extends "res://Objects/Actors/Enemies/Enemy.gd"

func _ready():
	._ready();
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'attack' : $States/Attack,
	'hurt' : $States/Hurt
	};