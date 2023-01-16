extends Area2D

const REGULAR_MUSIC = preload("res://musics/overworld theme loop.wav")
const BOSS_MUSIC = preload("res://musics/overworld theme rock remix.wav")

func _ready():
	self.connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		$"../Music".stream = BOSS_MUSIC
		$"../Music".play()
