extends Node

var can_skip := false

@export var default_font: Font = null

func haptic_feedback() -> void:
	Input.vibrate_handheld(3, 0.5)

func _enter_tree() -> void:
	if Settings.file.game.lang != "jp":
		for i in [$Title, $"1", $"2", $Enjoy]:
			i.remove_theme_font_override("font")
			i.uppercase = true

func _ready() -> void:
	Global.debugged_in = false
	Global.get_node("GameHUD").hide()
	Global.get_node("OnScreenControls").hide()
	# always display disclaimer, romverifier, resourcegenerator in original aspect ratio for aesthetic reasons
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	#print("hello")
	#get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	await get_tree().create_timer(1, false).timeout
	can_skip = true

func _exit_tree() -> void:
	Global.get_node("GameHUD").show()
	Global.get_node("OnScreenControls").show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump_0") and can_skip:
		go_to_menu()

func on_screen_tapped() -> void:
	if can_skip:
		haptic_feedback()
		go_to_menu()

func go_to_menu() -> void:
	if Global.rom_path == "":
		Global.transition_to_scene("res://Scenes/Levels/RomVerifier.tscn")
	elif not Global.rom_assets_exist:
		Global.transition_to_scene("res://Scenes/Levels/RomResourceGenerator.tscn")
	else:
		Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")
