extends GridContainer


onready var indicatorLight = get_parent().get_parent().get_node("IndicatorLight")
onready var audioPlayerPositive = get_node("PositivePlayer")
onready var audioPlayerNegative = get_node("NegativePlayer")
onready var topLineTexture = get_parent().get_node("TopBonusLine")
onready var middleLineTexture = get_parent().get_node("MiddleBonusLine")
onready var bottomLineTexture = get_parent().get_node("BottomBonusLine")
var possibleNumbers = []
var cardMatrix = [[],[],[]]
var prizeControlMatrix = [[],[],[]]
var cardNumbers = []
var auxMatrixNumber = 0
var bonusText = ""
var canAnimateLightGreen = false
var canAnimateLightRed = false
var canPlayTopLineAnimation = false
var canPlayMiddleLineAnimation = false
var canPlayBottomLineAnimation = false
var canPlayBingoAnimation = false
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	indicatorLight.modulate = Color(1,1,1)
	pickCardNumbersFromPossible()
	
	for i in 5:
		prizeControlMatrix[0].push_back(false)
		prizeControlMatrix[1].push_back(false)
		prizeControlMatrix[2].push_back(false)
		
		
func _process(delta):
	
	if canPlayTopLineAnimation:
		playTopLineAnimation(delta)
		
	if canPlayMiddleLineAnimation:
		playMiddleLineAnimation(delta)
		
	if canPlayBottomLineAnimation:
		playBottomLineAnimation(delta)


# Checks if the player's card contains extracted number and updates cards numbers color.
# If the player's card contains the extracted number then a "positive" sound will be played and
# a function will be called, else a negative sound is played.
func checkIfCardContainsNumber(number):	
	if cardNumbers.has(number):
		for i in self.get_children():
			if i.name != "NegativePlayer" and i.name != "PositivePlayer": 
				if(number == int(i.get_child(0).text)):
					i.get_child(0).modulate = Color(0.3,0.8,1.1)
		audioPlayerPositive.play()
		updatePrizeMatrix(number)
	else:
		audioPlayerNegative.play()
		
		
func updatePrizeMatrix(number):
	if cardMatrix[0].has(number):
		var index = cardMatrix[0].find(number)
		prizeControlMatrix[0][index] = true
	
	elif cardMatrix[1].has(number):
		var index = cardMatrix[1].find(number)
		prizeControlMatrix[1][index] = true
		
	elif cardMatrix[2].has(number):
		var index = cardMatrix[2].find(number)
		prizeControlMatrix[2][index] = true
		
	checkIfBonus()
	
	
func checkIfBonus():
	if !prizeControlMatrix[0].has(false) and !canPlayTopLineAnimation:
		bonusText = "TOP LINE"
		playBonusAnimation(bonusText)
		canPlayTopLineAnimation = true
		
	if !prizeControlMatrix[1].has(false) and !canPlayMiddleLineAnimation:
		bonusText = "MIDDLE LINE"
		playBonusAnimation(bonusText)
		canPlayMiddleLineAnimation = true
		
	if !prizeControlMatrix[2].has(false) and !canPlayBottomLineAnimation:
		bonusText = "BOTTOM LINE"
		playBonusAnimation(bonusText)
		canPlayBottomLineAnimation = true
		
	if !prizeControlMatrix[0].has(false) and !prizeControlMatrix[1].has(false) and !prizeControlMatrix[2].has(false) and !canPlayBingoAnimation :
		bonusText = "BINGO"
		playBonusAnimation(bonusText)
		canPlayBingoAnimation = true
		
		
func pickCardNumbersFromPossible():
	
	for n in 15:	
		var randomNumber = rng.randi_range(0,possibleNumbers.size() - 1)
		var generatedNumber = possibleNumbers[randomNumber]
		possibleNumbers.erase(generatedNumber)
		cardNumbers.push_back(generatedNumber)
	
	cardNumbers.sort()
	orderCardMatrix(cardNumbers)
	
	
func orderCardMatrix(cardNumbers):
	for i in 5:
		for j in 3:
			cardMatrix[j].push_back(cardNumbers[auxMatrixNumber])
			auxMatrixNumber += 1	
			
	fillCardNumbers()


func fillCardNumbers():
	for i in 5:
		self.get_child(i).get_child(0).text = str(cardMatrix[0][i])
		self.get_child(i + 5).get_child(0).text = str(cardMatrix[1][i])
		self.get_child(i + 10).get_child(0).text = str(cardMatrix[2][i])


func playTopLineAnimation(delta):
	if topLineTexture.rect_size.x < 500:
		topLineTexture.rect_size.x += 2000  * delta
	
	if topLineTexture.rect_size.x >= 500:
		topLineTexture.modulate.a -= 2 * delta
		
		
func playMiddleLineAnimation(delta):
	if middleLineTexture.rect_size.x < 500:
		middleLineTexture.rect_size.x += 2000 * delta
	
	if middleLineTexture.rect_size.x > 500:
		middleLineTexture.modulate.a -= 2 * delta
		
		
func playBottomLineAnimation(delta):
	if bottomLineTexture.rect_size.x < 500:
		bottomLineTexture.rect_size.x += 2000 * delta
	
	if bottomLineTexture.rect_size.x > 500:
		bottomLineTexture.modulate.a -= 2 * delta
		
func playBonusAnimation(bonusText):
	var bonusTextNode = self.get_parent().get_parent().get_node("BonusText")
	bonusTextNode.text = bonusText
	var tween = bonusTextNode.get_node("BonusTextTween")
	tween.interpolate_property(bonusTextNode, "rect_position",Vector2(-1600, 280), Vector2(2000, 280), 2, Tween.TRANS_EXPO, Tween.EASE_OUT_IN)
	tween.start()	
	


			
		
		

		
		
	
