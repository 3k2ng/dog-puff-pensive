extends Slider


export var bus_name: String
export var set_value_on_ready: bool = false
var bus_id: int

func _ready():
	var _success = self.connect("value_changed", self, "set_volume")
	bus_id = AudioServer.get_bus_index(bus_name)
	if set_value_on_ready:
		set_volume(value)
	else:
		value = db2linear(AudioServer.get_bus_volume_db(bus_id))

func set_volume(value: float):
	AudioServer.set_bus_volume_db(bus_id, linear2db(value))
