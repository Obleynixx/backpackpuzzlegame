extends AudioStreamPlayer

func PlayOneShotCombined(a,b,recipe):
	play_one_shot(recipe.recipeSound, self.volume_db)

func PlayOneShotSingleUsed(it, singleUseId, rule):
	play_one_shot(rule.singleUseSound, self.volume_db)

func play_one_shot(clip: AudioStream, volume_db := 0.0):
	if clip == null: return
	var temp := AudioStreamPlayer.new()
	temp.stream = clip
	temp.volume_db = volume_db
	add_child(temp)
	temp.play()
	temp.finished.connect(func(): temp.queue_free())
