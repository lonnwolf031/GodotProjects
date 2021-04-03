extends Control

# add toggle trigger stuff

onready var _scorecardTxture = $scorecard
onready var _buttonContainer = $scorecard/ButtonContainer

var blueChecked = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#untoggle all childs of button container
	scale()
	pass

func scale():
	var _size = _scorecardTxture.rect_size
	_buttonContainer.rect_size = _size
	pass

func _on_scorecard_resized():
	scale()
	pass


func _on_CheckBox2Blue_toggled(button_pressed):
	var _check = find_node("check")
	if _check.is_visible():
		_check.hide()
	else:
		_check.show()
	pass # Replace with function body.
