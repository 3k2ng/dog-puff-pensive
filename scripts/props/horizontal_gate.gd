extends StaticBody2D

const OPENING_SOUND = preload("res://sfxs/gate open.wav")

export var id: String

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var is_open: bool = false

func _process(_delta: float) -> void:
	if is_open:
		return
	for i in get_tree().get_nodes_in_group("id"):
		if i.id == id:
			if i.is_in_group("enemy"):
				if not i.get("dead"):
					return
			if i.is_in_group("button") and not i.activated:
				return
	anim_player.play("open_gate")
	$Audio.stream = OPENING_SOUND
	$Audio.play()
	is_open = true
