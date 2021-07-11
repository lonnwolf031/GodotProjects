extends Node

class_name Scores

var _numBlueToggles = 0
var _numRedToggles = 0
var _numYellowToggles = 0
var _numPurpleToggles = 0
var _numNoScoreToggles = 0

var _blueToggled = {}
var _redToggled = {}
var _yellowToggled = {}
var _purpleToggled = {}
var _noScoreToggled = {}

func _init():
	var _totalscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func countRowScore(_numToggled):
	var _rowScore = 0
	match _numToggled:
		1:
			_rowScore = 1
		2:
			_rowScore = 3
		3:
			_rowScore = 6
		4:
			_rowScore = 10
		5:
			_rowScore = 15
		6:
			_rowScore = 21
		7:
			_rowScore = 28
		8:
			_rowScore = 36
		9:
			_rowScore = 45
		10:
			_rowScore = 55
		11:
			_rowScore = 66
		12:
			_rowScore = 78
	return _rowScore
