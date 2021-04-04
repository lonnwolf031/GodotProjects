extends Control

# add toggle trigger stuff

onready var _scorecardTxture = $scorecard
#onready var _buttonContainer = $scorecard/BlueButtonContainer
onready var _scorecardTxtureSizeOrig = _scorecardTxture.get_size()
onready var _checkboxes = get_tree().get_nodes_in_group("checkboxes")
onready var _buttoncontainers = get_tree().get_nodes_in_group("buttoncontainers")
onready var _buttonContainerPosOrig = _buttoncontainers[0].get_position()
onready var _buttonContainerSizeOrig = _buttoncontainers[0].get_size()
onready var _checkboxSizeOrig = _checkboxes[0].get_size()

var toggled = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#for b in get_node("buttons").get_children():
	for b in _checkboxes:
		if b is Button:
			b.connect("pressed", self, "_button_pressed",[b])
	#untoggle all childs of button container
	
	scale_reposition()
	pass

func scale_reposition():
	var _scorecardSize = _scorecardTxture.get_size() #returns Vector2
	var _newContainerXsize = _scorecardSize.x * _buttonContainerSizeOrig.x / _scorecardTxtureSizeOrig.x
	var _newContainerYsize = _scorecardSize.y * _buttonContainerSizeOrig.y / _scorecardTxtureSizeOrig.y
	for _container in _buttoncontainers:
		_container.set_size(Vector2(_newContainerXsize, _newContainerYsize))
	var _newContainerSize = _buttoncontainers[0].get_size()
	var _newCheckboxXSize = _newContainerSize.x  * _checkboxSizeOrig.x / _buttonContainerSizeOrig.x
	var _newCheckboxYSize = _newContainerSize.y * _checkboxSizeOrig.y / _buttonContainerSizeOrig.y
	for _checkbox in _checkboxes:
		_checkbox.set_size(Vector2(_newCheckboxXSize,_newCheckboxYSize))
		pass
	#_buttonContainer.set_size(Vector2(_newXsize, _newYsize))
	#_buttonContainer.set_position()
	var _newContainerPosX = _buttonContainerPosOrig.x * _newContainerXsize / _buttonContainerSizeOrig.x 
	var _newContainerPosY = _buttonContainerPosOrig.y * _newContainerYsize / _buttonContainerSizeOrig.y 
	for _container in _buttoncontainers:
		_container.set_position(Vector2(_newContainerPosX,_newContainerPosY))
	pass
	

func _on_scorecard_resized():
	scale_reposition()
	pass

func _checkToggled(sender):
	
	pass
	
func _button_pressed(which):
	print("Button was pressed: ", which.get_name())
	var _sentby = which.get_name()
	var _check = which.get_node("check")
	if _check.is_visible():
		#if(!toggled.has(sender)):
		toggled[_sentby] = false
		_check.hide()
	else:
		#if(!toggled.has(sender)):
		toggled[_sentby] = true
		_check.show()
	print(str(toggled))
	
