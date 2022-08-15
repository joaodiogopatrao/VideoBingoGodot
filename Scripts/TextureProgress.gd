extends TextureProgress


var progressValue = 0
var canStartExtraction = false

func _ready():
	self.value = progressValue
	
	
func _process(delta):
	if canStartExtraction:
	 increaseProgressBar(delta)
	
	
func increaseProgressBar(delta):
	if progressValue < 19000:
		progressValue += 1000 * delta
	
	if progressValue >= 19000:
		progressValue = 19000
	self.value = progressValue
