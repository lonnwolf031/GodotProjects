extends Control

# make this some icon with random color
const _crown = preload("res://img/crown.png")

#onready var _list = $HBoxContainer/VBoxContainer/ItemList
onready var _tablist = $VBoxContainer/HBoxContainer/SubVBoxContainer/Tabs
onready var _action = $VBoxContainer/HBoxContainer/SubVBoxContainer/Action
onready var _rolldice = $VBoxContainer/DiceContainer/RollButton
onready var _dicecontainer = $VBoxContainer/DiceContainer
onready var dColorArr = ["purple", "blue", "orange", "yellow", "white", "white"]

var _players = []
var _playersDict = {}
var _turn = -1
var dice = {}
var scorecards = {}

var cPurple = Color("#8f02ed")
var cBlue = Color("#02beed")
var cOrange = Color("#ed4902")
var cYellow = Color("#edbe02")
var cWhite = Color("#ffffff")

var diceColorArr = [cPurple, cBlue, cOrange, cYellow, cWhite, cWhite]

var diceArr = []

const NUMDICES = 6

var clicked = false

master func set_player_name(name):
	var sender = get_tree().get_rpc_sender_id()
	rpc("update_player_name", sender, name)

sync func update_player_name(player, _name):
	var pos = _players.find(player)
	if pos != -1:
		#_list.set_item_text(pos, name)
		pass

master func request_action(action):
	var sender = get_tree().get_rpc_sender_id()
	if _players[_turn] != get_tree().get_rpc_sender_id():
		#rpc("_log", "Someone is trying to cheat! %s" % str(sender))
		return
	do_action(action)

	next_turn()
	
func loaddice():
	for _side in range(1,7):
		for _color in dColorArr:
			var _dicename = str(_side) + _color
			var _path = "res://img/side" + _dicename + ".png"
			dice[_dicename] = load(_path)

func rollDice():
	diceArr.clear()
	var _shuffledColorArr = shuffleList(dColorArr)
	# range is inclusive, exclusive
	for _numdice in range(1,7):
		var _num = randi() % 6 + 1
		# check if indeed is BETWEEN 0 and 7, otherwise +1
		var _nodeName = "dice" + str(_numdice)
		var _dice = _dicecontainer.find_node(_nodeName)
		print(_dice.get_name())
		# below: second roll got index 0 from arr
		print(str(_shuffledColorArr))
		var _rolledDiceName = str(_num) + _shuffledColorArr[_numdice-1]
		var _rolledDiceTextureName = "side" + _rolledDiceName
		diceArr.append(_rolledDiceName)
		_dice.texture = dice[_rolledDiceName]
	

func shuffleList(originallist):
	var list = [] + originallist
	var shuffledList = []
	var indexList = range(list.size())
	for _i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList

# HERE GOES ACTION WITH THE TURN
sync func do_action(action):
	#check if turn
	rollDice()
	clicked = true
	#var name = _list.get_item_text(_turn)
	#rpc("_log", "%s: %ss %d" % [name, action, val])


sync func set_turn(turn):
	_turn = turn
	if turn >= _players.size():
		return
	for i in range(0, _playersDict.size()):
		if i == turn:
			_action.disabled = false
			#_playByRulesRolledDice()
			pass
		else:
			#_playByRulesOthers()
			#_list.set_item_icon(i, null)
			pass
	if _players[turn] != get_tree().get_network_unique_id():
		_action.disabled = true
	elif clicked == true:
		_action.disabled = true
	else:
		_action.disabled = false


sync func del_player(id):
	var pos = _players.find(id)
	if pos == -1:
		return
	_players.remove(pos)
	#_list.remove_item(pos)
	if _turn > pos:
		_turn -= 1
	if get_tree().is_network_server():
		rpc("set_turn", _turn)



sync func add_player(id, name=""):
	_players.append(id)
	#var _newPlayer = Player.new(id, name)
	#var _newPlayer = preload("res://scene/Player.tscn")
	#var newPlayer = _newPlayer.instance()
	var newplayer = KwixxPlayer.new()
	newplayer.id = id
	newplayer.name  = name
	_playersDict[id] = newplayer
	if name == "":
		name = "unknown"
	var _newPanel = PanelContainer.new()
	_newPanel.set_name(newplayer.name)
	_newPanel.set_size(Vector2(200, 200),false)  
	_tablist.add_child(_newPanel)
	var _newScorecard = preload("res://scene/Scorecard.tscn")
	var newScorecard = _newScorecard.instance()
	newScorecard.set_name(str(id))
	newScorecard.find_node("scorecard").set_expand(true)
	newScorecard.find_node("scorecard").set_stretch_mode(5)
	scorecards[id] = newScorecard
	_newPanel.add_child(newScorecard)

class KwixxPlayer:
	var id: int
	var name: String
	# make new Scores instance
	var scores: Scores

func next_turn():
	clicked = false
	_turn += 1
	if _turn >= _players.size():
		_turn = 0
	rpc("set_turn", _turn)


func start():
	set_turn(0)
	loaddice()


func stop():
	_players.clear()
	#_list.clear()
	_turn = 0
	_action.disabled = true

# ADD THING TO MAX PLAYERS
func on_peer_add(id):
	if not get_tree().is_network_server():
		return
	for _i in range(0, _players.size()):
		#rpc_id(id, "add_player", _players[i], get_player_name(i))
		pass
	rpc("add_player", id)
	rpc_id(id, "set_turn", _turn)


func on_peer_del(id):
	if not get_tree().is_network_server():
		return
	rpc("del_player", id)

func _on_Action_pressed():
	if get_tree().is_network_server():
		do_action("roll")
		print("roll is done")
		_action.set_disabled(true)
		#disable button
		next_turn()
	else:
		rpc_id(1, "request_action", "roll")
		
func _playByRulesRolledDice(player):
	var _whitesum = 0
	var _whiteopts = []
	var _purpleopts = []
	var _orangeopts = []
	var _yellowopts = []
	var _blueopts = []
	var playercard = scorecards[player.id]
	for _die in diceArr:
		if "white" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_whitesum += _i
					_whiteopts.append(_i)
		if "purple" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_purpleopts.append(_i)
		if "orange" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_orangeopts.append(_i)
		if "yellow" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_yellowopts.append(_i)
		if "blue" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_blueopts.append(_i)
	for _cbox in playercard._checkboxes:
		if _cbox is Button:
			_cbox.set_disabled(true)
		print(_cbox.get_name())
		# get all checkboxes
		# disable all
		# loop through checkboxes
			# enable options , store clicked
		
	#disable non clickable options on card based on dice in dice array
	pass
	
func _playByRulesOthers(player):
	var playercard = scorecards[player.id]
	var _whitesum = 0
	for _die in diceArr:
		if "white" in _die.get_name():
			for _i in range(1,7):
				if _i in _die.get_name():
					_whitesum += _i
	#disable non clickable options on card based on dice in dice array
	pass
	


func _on_RollButton_pressed():
	if get_tree().is_network_server():
		do_action("roll")
		print("roll is done")
		#disable button
		_action.set_disabled(true)
		next_turn()
	else:
		rpc_id(1, "request_action", "roll")
