extends TextureRect

var numberTexture = preload("res://Scenes/NumberTexture.tscn")
onready var playerNumbers = get_parent().get_node("PlayerCard/PlayerNumbers")
onready var pickedNumbersInd = get_parent().get_node("PickedNumberInd")
onready var progressBar = get_parent().get_node("ProgressBackground").get_node("TextureProgress")

var numberTextureInstances = []
var extractedNumbersArray = []
var sortedChildren = []
var rng = RandomNumberGenerator.new()
var possibleNumbersArray = []
var canStartExtraction = false
var auxNumber = 0
var topNumberFlag = 0
var bottomNumberFlag = 15
var auxTimer = 0
var extractedNumbersArrayDuplicate = []
var possibleNumbers = 60
var extractedNumbers = 30
var ballSpawnSpeed = 0.5
var circle1 = preload("res://Sprites/circle01.png")
var circle2 = preload("res://Sprites/circle02.png")
var circle3 = preload("res://Sprites/circle03.png")
var circle4 = preload("res://Sprites/circle04.png")
var circle5 = preload("res://Sprites/circle05.png")
var circle6 = preload("res://Sprites/circle06.png")


func _ready():
	rng.randomize()

	for i in self.get_children():
		sortedChildren.push_back(i)
		
	for i in possibleNumbers:
		possibleNumbersArray.push_back(i)
		
	var possibleNumbersArrayDuplicate = possibleNumbersArray.duplicate()
	
	for n in extractedNumbers:	
		var randomNumber = rng.randi_range(0,possibleNumbersArrayDuplicate.size() -1)
		var generatedNumber = possibleNumbersArrayDuplicate[randomNumber]
		possibleNumbersArrayDuplicate.erase(generatedNumber)
		extractedNumbersArray.push_back(generatedNumber)

	playerNumbers.possibleNumbers = possibleNumbersArray
	
func _process(delta):
		
	if canStartExtraction:
		if auxNumber < extractedNumbers:
			auxTimer +=  delta
			if(auxTimer >= ballSpawnSpeed):
				if auxNumber % 2 == 0:
					instantiateBall(extractedNumbersArray[auxNumber],sortedChildren[topNumberFlag].rect_position,"top")
					topNumberFlag += 1
				else:
					instantiateBall(extractedNumbersArray[auxNumber],sortedChildren[bottomNumberFlag].rect_position,"bottom")
					bottomNumberFlag += 1
				auxNumber += 1
				auxTimer = 0
				
				
func instantiateBall(number,goalPosition,row):
	
	var numberTextureInstance = numberTexture.instance()
	numberTextureInstances.push_back(numberTextureInstance)
	var tween = numberTextureInstance.get_node("TweenPosition")
	var tweenRotation = numberTextureInstance.get_node("TweenRotation")
	
	numberTextureInstance.get_child(0).text = str(number)
	
	if number < 10:
		numberTextureInstance.texture = circle1
	elif number >= 10 and number < 20:
		numberTextureInstance.texture = circle2
	elif number >= 20 and number < 30:
		numberTextureInstance.texture = circle3
	elif number >= 30 and number < 40:
		numberTextureInstance.texture = circle4
	elif number >= 40 and number < 50:
		numberTextureInstance.texture = circle5
	else:
		numberTextureInstance.texture = circle6
		
	self.add_child(numberTextureInstance)
	
	if(row == "top"):
		tween.connect("tween_completed",self,"on_tween_completed")
		tween.interpolate_property(numberTextureInstance, "rect_position",Vector2(1750, 106), goalPosition, 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	
		tweenRotation.interpolate_property(numberTextureInstance, "rect_rotation",360, -360, 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tweenRotation.start()
		
	elif(row == "bottom"):
		tween.connect("tween_completed",self,"on_tween_completed")
		tween.interpolate_property(numberTextureInstance, "rect_position",Vector2(1750, 212), goalPosition, 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		tweenRotation.interpolate_property(numberTextureInstance, "rect_rotation",-360, 360, 3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tweenRotation.start()


func on_tween_completed(object,key):
	var number = int(object.get_child(0).text)
	playerNumbers.checkIfCardContainsNumber(number)
	pickedNumbersInd.receivePickedNumber(number)
	
	
func _on_PlayButton_pressed():
	if !canStartExtraction:
		canStartExtraction = true
		progressBar.canStartExtraction = true
		for i in numberTextureInstances:
			var tween = i.get_node("TweenPosition")
			var tweenRotation = i.get_node("TweenRotation")
			tween.resume_all()
			tweenRotation.resume_all()
	else:
		get_tree().reload_current_scene()
		
		
func _on_StopButton_pressed():
	canStartExtraction = false
	progressBar.canStartExtraction = false
	for i in numberTextureInstances:
		var tween = i.get_node("TweenPosition")
		var tweenRotation = i.get_node("TweenRotation")
		tween.stop_all()
		tweenRotation.stop_all()
		
