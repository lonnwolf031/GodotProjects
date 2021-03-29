extends BaseClass

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
  for i in range(len(diceArr)):
    # check if indeed is BETWEEN 0 and 7, otherwise +1
    num = randi() % 7
    # make node for dice, add to diceArr
    # set sprite to  string dicename = "Dice" + i.ToString();
    # set background color to diceColorArr[i]


func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList
