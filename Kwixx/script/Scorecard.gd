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
var checkboxSizes = {}
var containerSizesOrig = {}
var containerPosOrig = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for _c in _checkboxes:
		checkboxSizes[_c.get_name()] = _c.get_size()
		if _c is Button:
			_c.connect("pressed", self, "_button_pressed",[_c])
	for _container in _buttoncontainers:
		containerSizesOrig[_container.get_name()] = _container.get_size()
		containerPosOrig[_container.get_name()] = _container.get_position()
	#untoggle all childs of button container
	scale_reposition()
	print("at start ", str(_scorecardTxture.get_size()))


func scale_reposition():
	var _scorecardSize = _scorecardTxture.get_size() #returns Vector2
	print("get size: ", str(_scorecardTxture.get_size()))
	for _container in _buttoncontainers:
		#var _newContainerXsize = _scorecardSize.x * containerSizesOrig[_container.get_name()].x / _scorecardTxtureSizeOrig.x
		#var _newContainerYsize = _scorecardSize.y * containerSizesOrig[_container.get_name()].y  / _scorecardTxtureSizeOrig.y
		var _new_Container_sizes = resize_container_by_ratio(_container)
		var _newContainerXsize = _new_Container_sizes.x
		var _newContainerYsize = _new_Container_sizes.y
		_container.set_size(Vector2(_newContainerXsize, _newContainerYsize))
		#var _newContainerXsize = resize_values_by_ratio(target_size, image_size).x
		#var _newContainerYsize resize_values_by_ratio(target_size, image_size).y
		#_container.set_size()
		var _newContainerPosX = containerPosOrig[_container.get_name()].x * _newContainerXsize / _buttonContainerSizeOrig.x 
		var _newContainerPosY = containerPosOrig[_container.get_name()].y * _newContainerYsize / _buttonContainerSizeOrig.y 
		_container.set_position(Vector2(_newContainerPosX,_newContainerPosY))
	for _checkbox in _checkboxes:
		var _parent = _checkbox.get_parent()
		if _parent is HBoxContainer:
			var _newCheckboxXSize = _parent.get_size().x * _checkboxSizeOrig.x / containerSizesOrig[_parent.get_name()].x
			var _newCheckboxYSize = _parent.get_size().y * _checkboxSizeOrig.y / containerSizesOrig[_parent.get_name()].y
			_checkbox.set_size(Vector2(_newCheckboxXSize,_newCheckboxYSize))
		elif _parent is Button:
			_checkbox.set_size(Vector2(_parent.get_size().x, _parent.get_size().y))

func resize_values_by_ratio(scorecard_new_size, element_size):
	var scorecard_orig_ratio = _scorecardTxtureSizeOrig.y / _scorecardTxtureSizeOrig.x
	var scorecard_new_ratio = scorecard_new_size.y / scorecard_new_size.x
	var scorecard_scale_y = scorecard_new_size.y / _scorecardTxtureSizeOrig.y
	# check ratios, compare, return right values
	# if element.x > element.y > ratio * largest
	var resize_width = scorecard_scale_y * element_size.x
	var resize_height = scorecard_new_ratio * scorecard_scale_y * element_size.y
	return Vector2(resize_width, resize_height)

func resize_container_by_ratio(component):
	var ratio
	var resize_width 
	var resize_height 
	var _orign_size = containerSizesOrig[component.get_name()]
	var scale = _scorecardTxture.get_size().x / _scorecardTxtureSizeOrig.x
	if (_orign_size.x > _orign_size.y):
		ratio = _orign_size.y / _orign_size.x
		resize_width = scale * containerSizesOrig[component.get_name()].x
		resize_height = scale * ratio * containerSizesOrig[component.get_name()].x 
	else:
		ratio = _orign_size.x / _orign_size.y
		resize_width = scale * ratio * containerSizesOrig[component.get_name()].y
		resize_height = scale * containerSizesOrig[component.get_name()].y 
	

	return Vector2(resize_width, resize_height)

func _on_scorecard_resized():
	scale_reposition()
	pass
	
func _button_pressed(which):
	print("Button was pressed: ", which.get_name())
	_toggle(which)
	print("on click ", str(_scorecardTxture.get_size()))
	
func _toggle(sentby):
	var _sentby = sentby.get_name()
	var _check = sentby.get_node("check")
	if _check.is_visible():
		toggled[_sentby] = false
		_check.hide()
	else:
		toggled[_sentby] = true
		_check.show()
	
