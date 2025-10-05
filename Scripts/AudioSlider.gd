extends HSlider

@export var bus_name := "Master"
@export var default_volume := 0.5

func _ready():
	min_value = 0.0
	max_value = 1.0
	step = 0.01

	var saved = ProjectSettings.get_setting("user/audio/%s" % bus_name, default_volume)
	value = saved
	_apply_volume(value)

	value_changed.connect(_on_value_changed)

func _on_value_changed(v: float):
	_apply_volume(v)
	ProjectSettings.set_setting("user/audio/%s" % bus_name, v)
	ProjectSettings.save()

func _apply_volume(v: float):
	var idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, linear_to_db(v))
