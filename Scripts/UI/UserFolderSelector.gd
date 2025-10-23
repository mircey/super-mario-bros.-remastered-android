class_name UserFolderSelector
extends Node

const VALID_HASH := "c9b34443c0414f3b91ef496d8cfee9fdd72405d673985afa11fb56732c96152b"

var android_access_granter

var initial_campaign := "SMB1"

func haptic_feedback() -> void:
	Input.vibrate_handheld(3, 0.5)

func _ready() -> void:
	initial_campaign = Global.current_campaign
	Global.campaign_is_dummy = true
	Global.current_campaign = "SMBLL"
	Global.level_theme_changed.emit()
	Global.get_node("GameHUD").hide()
	OnScreenControls.should_show = false
	await get_tree().physics_frame
	android_access_granter = Engine.get_singleton("AndroidDirectoryAccessGranter")
	android_access_granter.directory_access_granted.connect(on_directory_access_granted)

func on_screen_tapped() -> void:
	haptic_feedback()
	android_access_granter.openDirectory("") # does open up as intended

func on_directory_access_granted(folder_path: String) -> void:
	print("folder selected!!!: ", folder_path) # is never reached
	#verified()

func error() -> void:
	%Error.show()
	$ErrorSFX.play()

func verified() -> void:
	$BGM.queue_free()
	%DefaultText.queue_free()
	%SuccessMSG.show()
	$SuccessSFX.play()
	#await get_tree().create_timer(3, false).timeout
	#if not Global.rom_assets_exist:
		#Global.transition_to_scene("res://Scenes/Levels/RomResourceGenerator.tscn")
	#else:
		#Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")
	Global.transition_to_scene("res://Scenes/Levels/RomVerifier.tscn")

func _exit_tree() -> void:
	Global.get_node("GameHUD").show()
	OnScreenControls.should_show = true
	Global.campaign_is_dummy = false
	Global.current_campaign = initial_campaign
	Global.level_theme_changed.emit()

func create_file_pointer(file_path := "") -> void:
	var pointer = FileAccess.open(Global.ROM_POINTER_PATH, FileAccess.WRITE)
	pointer.store_string(file_path)
	pointer.close()
