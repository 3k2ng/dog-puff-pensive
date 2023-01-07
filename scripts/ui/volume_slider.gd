extends Slider


export var bus_name: String
var bus_id: int

func _ready():
	var _success = self.connect("value_changed", self, "set_volume")
	bus_id = AudioServer.get_bus_index(bus_name)
	set_volume(value)

func set_volume(value: float):
	AudioServer.set_bus_volume_db(bus_id, linear2db(value))
