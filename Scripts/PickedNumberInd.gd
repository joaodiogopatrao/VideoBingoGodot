extends Label

var scaleSize = 0
var alphaValue = 120
var canAnimate = false


func _ready():
	pass
	self.modulate.a = alphaValue / 255
	
	
func _process(delta):
	self.modulate.a = alphaValue/255
	self.rect_scale = Vector2(scaleSize,scaleSize)
	if canAnimate:
		if scaleSize < 1:
			scaleSize += 2.3 * delta
			alphaValue -= 276 * delta
			
			
func receivePickedNumber(number):
	alphaValue = 120
	scaleSize = 0
	canAnimate = true
	self.text = str(number)
	
