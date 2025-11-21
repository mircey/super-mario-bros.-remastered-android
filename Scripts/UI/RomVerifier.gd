class_name ROMVerifier
extends Node

const VALID_HASH := "c9b34443c0414f3b91ef496d8cfee9fdd72405d673985afa11fb56732c96152b"

var android_picker = null
var file_picker_ready := false

func haptic_feedback() -> void:
	Input.vibrate_handheld(3, 0.5)

func _ready() -> void:
	Global.get_node("GameHUD").hide()
	OnScreenControls.should_show = false
	
	# Initialize the file picker with proper checks
	initialize_file_picker()

func initialize_file_picker() -> void:
	# Wait a bit longer to ensure everything is loaded
	await get_tree().create_timer(0.1).timeout
	
	if Engine.has_singleton("AndroidFilePicker"):
		android_picker = Engine.get_singleton("AndroidFilePicker")
		if android_picker:
			if android_picker.has_signal("file_picked"):
				android_picker.file_picked.connect(on_file_selected)
				file_picker_ready = true
				print("Android file picker connected successfully")
			else:
				push_error("AndroidFilePicker doesn't have 'file_picked' signal")
		else:
			push_error("AndroidFilePicker singleton is null")
	else:
		push_error("AndroidFilePicker singleton not found")
		# Fallback for other platforms
		setup_desktop_fallback()

func setup_desktop_fallback() -> void:
	# You can implement a desktop file dialog fallback here
	print("Using desktop file picker fallback")
	# Example: %FileDialog.connect("file_selected", on_desktop_file_selected)

func on_screen_tapped() -> void:
	haptic_feedback()
	
	if file_picker_ready and android_picker:
		android_picker.openFilePicker("*/*")
	else:
		push_error("File picker not ready or not available")
		# Fallback to desktop file dialog
		# %FileDialog.popup_centered()

func on_file_selected(temp_path: String, mime_type: String) -> void:
	print("File selected: ", temp_path)
	
	if FileAccess.file_exists(temp_path):
		if is_valid_rom(temp_path):
			Global.rom_path = temp_path
			verified()
			copy_rom(temp_path)
		else:
			error()
		
		# Only remove if it's a temporary file
		if temp_path.begins_with("/tmp/") or temp_path.contains("cache"):
			DirAccess.remove_absolute(temp_path)
	else:
		push_error("Selected file doesn't exist: ", temp_path)
		error()

func copy_rom(file_path := "") -> void:
	if FileAccess.file_exists(file_path):
		DirAccess.copy_absolute(file_path, Global.ROM_PATH)
	else:
		push_error("Source file doesn't exist for copying: ", file_path)

static func get_hash(file_path := "") -> String:
	if not FileAccess.file_exists(file_path):
		return ""
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return ""
	
	var file_bytes = file.get_buffer(40976)
	if file_bytes.size() < 16:
		return ""
	
	var data = file_bytes.slice(16)
	return Marshalls.raw_to_base64(data).sha256_text()

static func is_valid_rom(rom_path := "") -> bool:
	if rom_path.is_empty() or not FileAccess.file_exists(rom_path):
		return false
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
	if pointer:
		pointer.store_string(file_path)
		pointer.close()
