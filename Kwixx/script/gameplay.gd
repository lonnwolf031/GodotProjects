extends Control
# right base class?

var cPurple = Color("#8f02ed")
var cBlue = Color("#02beed")
var cOrange = Color("#ed4902")
var cYellow = Color("#edbe02")
var cWhite = Color("#ffffff")

var diceColorArr = [cPurple, cBlue, cOrange, cYellow, cWhite, cWhite]

var diceArr = []

const NUMDICES = 6

func _ready():
	randomize()

func rollDice():
	shuffleList(diceColorArr)
	for i in range(0,7):
		var _num = randi() % 7
		# check if indeed is BETWEEN 0 and 7, otherwise +1
		# make node for dice, add to diceArr
		var nodeName = "dice" + str(i)
		s = Sprite.new()
		add_child(s) # Add it as a child of this node
		# set sprite to  string dicename = "Dice" + i.ToString();
		# set background color to diceColorArr[i]


func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for _i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList
