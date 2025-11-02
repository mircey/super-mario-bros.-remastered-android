extends Node

func window_mode_changed(new_value := 0) -> void:
	match new_value:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		#2:
			#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Settings.file.video.mode = new_value

func null_function(_fuck_you := 0) -> void:
	pass

func window_size_changed(new_value := 0) -> void:
	var center_container : CenterContainer = get_tree().root.get_node("Wrapper/CenterContainer")
	var screen_width = floor(center_container.size.x)
	var x = mini(screen_width if new_value == 2 else 384 if new_value == 1 else 256, screen_width)
	#var y = 
	print("WindowChanger/x: ", x)
	var game_viewport : SubViewport = get_tree().root.get_node("Wrapper/CenterContainer/SubViewportContainer/SubViewport")
	var game_viewport_container : SubViewportContainer = get_tree().root.get_node("Wrapper/CenterContainer/SubViewportContainer")
	game_viewport.size.x = x
	game_viewport_container.size.x = x
	
	Settings.file.video.size = new_value

func vsync_changed(new_value := 0) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if new_value == 1 else DisplayServer.VSYNC_DISABLED)
	Settings.file.video.vsync = new_value

func drop_shadows_changed(new_value := 0) -> void:
	Settings.file.video.drop_shadows = new_value

func scaling_changed(new_value := 0) -> void:
	get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER if new_value == 0 else Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	Settings.file.video.scaling = new_value

func visuals_changed(new_value := 0) -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT if new_value == 0 else Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	RenderingServer.viewport_set_snap_2d_transforms_to_pixel(get_tree().root.get_viewport_rid(), not new_value)
	Settings.file.video.visuals = new_value

func hud_style_changed(new_value := 0) -> void:
	Settings.file.video.hud_size = new_value

func language_changed(new_value := 0) -> void:
	TranslationServer.set_locale(Global.lang_codes[new_value])
	Settings.file.game.lang = Global.lang_codes[new_value]
	%Flag.region_rect.position.x = new_value * 16

func set_value(value_name := "", value := 0) -> void:
	{
		"mode": window_mode_changed,
		"size": window_size_changed,
		"vsync": vsync_changed,
		"drop_shadows": drop_shadows_changed,
		"scaling": scaling_changed,
		"visuals": visuals_changed,
		"palette": null_function,
		"hud_size": hud_style_changed,
		"hud_style": hud_style_changed
	}[value_name].call(value)
