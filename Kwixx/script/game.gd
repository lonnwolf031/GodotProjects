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

var cPurple = Color("#8f02ed")
var cBlue = Color("#02beed")
var cOrange = Color("#ed4902")
var cYellow = Color("#edbe02")
var cWhite = Color("#ffffff")

var diceColorArr = [cPurple, cBlue, cOrange, cYellow, cWhite, cWhite]

var diceArr = []

const NUMDICES = 6

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
		rpc("_log", "Someone is trying to cheat! %s" % str(sender))
		return
	do_action(action)
	next_turn()
	
	var _dice = preload("res://img/side1.png")

var _side1 = preload("res://img/side1.png")

func loaddice():
	for _side in range(1,7):
		for _color in dColorArr:
			var _dicename = str(_side) + _color
			print(_dicename)
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
		var _rolledDiceName = str(_num) + _shuffledColorArr[_numdice-1]
		var _rolledDiceTextureName = "side" + _rolledDiceName
		diceArr.append(_rolledDiceName)
		_dice.texture = dice[_rolledDiceName]

func shuffleList(list):
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
	# differntiate between sender and others for possible actions
	# roll dice
	rollDice()
	#var name = _list.get_item_text(_turn)
	var val = randi() % 100
	rpc("_log", "%s: %ss %d" % [name, action, val])


sync func set_turn(turn):
	_turn = turn
	if turn >= _players.size():
		return
	for i in range(0, _players.size()):
		if i == turn:
			#_list.set_item_icon(i, _crown)
			pass
		else:
			#_list.set_item_icon(i, null)
			pass
	_action.disabled = _players[turn] != get_tree().get_network_unique_id()


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
	var _newPlayer = preload("res://scene/Player.tscn")
	var newPlayer = _newPlayer.instance()
	_playersDict[id] = newPlayer
	if name == "":
		name = "unknown"
	newPlayer.set_name(str(id))
	var _newPanel = PanelContainer.new()
	_newPanel.set_name(name)
	_newPanel.set_size(Vector2(200, 200),false)  
	_tablist.add_child(_newPanel)
	_newPanel.add_child(newPlayer)
	var _newScorecard = preload("res://scene/Scorecard.tscn")
	var newScorecard = _newScorecard.instance()
	newScorecard.set_name(str(id))
	newScorecard.find_node("scorecard").set_expand(true)
	newScorecard.find_node("scorecard").set_stretch_mode(5)
	_newPanel.add_child(newScorecard)

func next_turn():
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


sync func _log(what):
	$VBoxContainer/HBoxContainer/RichTextLabel.add_text(what + "\n")


func _on_Action_pressed():
	if get_tree().is_network_server():
		do_action("roll")
		next_turn()
	else:
		rpc_id(1, "request_action", "roll")
