class_name ROMVerifier
extends Node

const VALID_HASH := "c9b34443c0414f3b91ef496d8cfee9fdd72405d673985afa11fb56732c96152b"

# implemented as per https://github.com/SeppNel/Godot-File-Picker/tree/main
var android_picker

func haptic_feedback() -> void:
	Input.vibrate_handheld(3, 0.5)

func _ready() -> void:
	Global.get_node("GameHUD").hide()
	OnScreenControls.should_show = false
	await get_tree().physics_frame
	android_picker = Engine.get_singleton("GodotFilePicker")
	android_picker.file_picked.connect(on_file_selected)

func on_screen_tapped() -> void:
	haptic_feedback()
	android_picker.openFilePicker("*/*")

func on_file_selected(temp_path: String, mime_type: String) -> void:
	if is_valid_rom(temp_path):
		Global.rom_path = temp_path
		verified()
		copy_rom(temp_path)
	else:
		error()

	DirAccess.remove_absolute(temp_path)

func copy_rom(file_path := "") -> void:
	DirAccess.copy_absolute(file_path, Global.ROM_PATH)

static func get_hash(file_path := "") -> String:
	var file_bytes = FileAccess.open(file_path, FileAccess.READ).get_buffer(40976)
	var data = file_bytes.slice(16)
	return Marshalls.raw_to_base64(data).sha256_text()

static func is_valid_rom(rom_path := "") -> bool:
	return get_hash(rom_path) == VALID_HASH

func error() -> void:
	%Error.show()
	$ErrorSFX.play()

func verified() -> void:
	$BGM.queue_free()
	%DefaultText.queue_free()
	%SuccessMSG.show()
	$SuccessSFX.play()
	await get_tree().create_timer(3, false).timeout
	if not Global.rom_assets_exist:
		Global.transition_to_scene("res://Scenes/Levels/RomResourceGenerator.tscn")
	else:
		Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")

func _exit_tree() -> void:
	Global.get_node("GameHUD").show()
	OnScreenControls.should_show = true

func create_file_pointer(file_path := "") -> void:
	var pointer = FileAccess.open(Global.ROM_POINTER_PATH, FileAccess.WRITE)
	pointer.store_string(file_path)
	pointer.close()
