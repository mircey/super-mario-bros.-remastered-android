class_name PlayerGhost
extends Node2D
@onready var sprite: PlayerSprite = $PlayerSprite

static var idx := 0

var recording := []

var current_power_state := ""

func delete() -> void:
	idx = 0

func apply_data(data := "") -> void:
	if Global.current_level == null || data == "":
		hide()
		return
	$Label.visible = SpeedrunHandler.ghost_idx < 60
	var values = data.split("=", false)
	global_position.x = int(values[0])
	global_position.y = int(values[1])
	
	sprite.force_power_state = ["Small", "Big", "Fire"][int(values[2])]
	if sprite.force_power_state != current_power_state:
		sprite.update()
	current_power_state = sprite.force_power_state
	sprite.animation = (SpeedrunHandler.anim_list[int(values[3])])
	sprite.frame = int(values[4])
	sprite.scale.x = int(values[5])
	
	visible = SpeedrunHandler.levels[int(values[6])] == Global.current_level.scene_file_path
