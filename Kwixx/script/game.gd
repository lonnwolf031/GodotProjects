extends Control

# make this some icon with random color
const _crown = preload("res://img/crown.png")

#onready var _list = $HBoxContainer/VBoxContainer/ItemList
onready var _tablist = $HBoxContainer/VBoxContainer/Tabs
onready var _action = $HBoxContainer/VBoxContainer/Action

var _players = []
var _turn = -1

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

# HERE GOES ACTION WITH THE TURN
sync func do_action(action):
	# differntiate between sender and others for possible actions
	# roll dice
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
	var _newPlayer = Player.new(id, name)
	# append scorecards 
	# on game start spawn all scorecards
	#_scorecards[id] = load("res://scene/Scorecard.tscn")
	
	#var projectile = load("res://Projectile.tscn")
	# when creating scene, foreach key in dict instance and add to tree
	#var bullet = projectile.instance()
	#add_child_below_node(get_tree().get_root().get_node("Game"),bullet)
	
	if name == "":
		#_list.add_item("... connecting ...", null, false)
		name = "unknown"
	#else:
		#_list.add_item(name, null, false)
		_tablist.add_child(_newPlayer)
	var _newPanel = Panel.new()
	_newPanel.rect_size = Vector2(200, 200)  # <-- added this
	_newPlayer.add_child(_newPanel)


#func get_player_name(pos):
	#if pos < _list.get_item_count():
		#return _list.get_item_text(pos)
	#else:
		#return "Error!"


func next_turn():
	_turn += 1
	if _turn >= _players.size():
		_turn = 0
	rpc("set_turn", _turn)


func start():
	set_turn(0)


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
	$HBoxContainer/RichTextLabel.add_text(what + "\n")


func _on_Action_pressed():
	if get_tree().is_network_server():
		do_action("roll")
		next_turn()
	else:
		rpc_id(1, "request_action", "roll")
