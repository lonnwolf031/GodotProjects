extends Control

class_name Player # , "res://path/to/optional/icon.svg"

var _playerid
var _playername

func _ready():
	pass

func _init():
	var _scores = Scores.new()
