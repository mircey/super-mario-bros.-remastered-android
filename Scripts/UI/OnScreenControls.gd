extends CanvasLayer

const LEFT = preload("res://Assets/Sprites/UI/OnScreenControls/Left.png")
const LEFT_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/LeftHeld.png")
const RIGHT = preload("res://Assets/Sprites/UI/OnScreenControls/Right.png")
const RIGHT_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/RightHeld.png")
const UP = preload("res://Assets/Sprites/UI/OnScreenControls/Up.png")
const UP_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/UpHeld.png")
const DOWN = preload("res://Assets/Sprites/UI/OnScreenControls/Down.png")
const DOWN_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/DownHeld.png")

const A = preload("res://Assets/Sprites/UI/OnScreenControls/A.png")
const A_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/AHeld.png")
const B = preload("res://Assets/Sprites/UI/OnScreenControls/B.png")
const B_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/BHeld.png")

const START = preload("res://Assets/Sprites/UI/OnScreenControls/Start.png")
const START_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/StartHeld.png")
const SELECT = preload("res://Assets/Sprites/UI/OnScreenControls/Select.png")
const SELECT_HELD = preload("res://Assets/Sprites/UI/OnScreenControls/SelectHeld.png")
const RUN_LOCK = preload("res://Assets/Sprites/UI/OnScreenControls/RunLock.png")
const RUN_LOCK_ON = preload("res://Assets/Sprites/UI/OnScreenControls/RunLockOn.png")

@onready var left = $Control/LeftSprite
@onready var right = $Control/RightSprite
@onready var up = $Control/UpSprite
@onready var down = $Control/DownSprite

@onready var a = $Control2/ASprite
@onready var b = $Control2/BSprite

@onready var start = $Control2/StartSprite
@onready var select = $Control/SelectSprite
@onready var run_lock = $Control2/RunLockSprite

var run_lock_on := false

var vibration_thread: Thread

func vibrate_asynchronously() -> void:
	vibration_thread = Thread.new()
	vibration_thread.start(vibrate)

func vibrate() -> void:
	Input.vibrate_handheld(3, 0.5)

func virtual_key(button_index : JoyButton, pressed : bool) -> void:
	var inputEvent := InputEventJoypadButton.new()
	inputEvent.button_index = button_index
	inputEvent.pressed = pressed
	Input.parse_input_event(inputEvent)

func virtual_key_press(button_index : JoyButton) -> void:
	virtual_key(button_index, true)

func virtual_key_release(button_index : JoyButton) -> void:
	virtual_key(button_index, false)

func on_west_pressed() -> void:
	left.texture = LEFT_HELD
	vibrate()
	virtual_key_press(JOY_BUTTON_DPAD_LEFT)

func on_west_released() -> void:
	left.texture = LEFT
	virtual_key_release(JOY_BUTTON_DPAD_LEFT)

func on_east_pressed() -> void:
	right.texture = RIGHT_HELD
	vibrate()
	virtual_key_press(JOY_BUTTON_DPAD_RIGHT)

func on_east_released() -> void:
	right.texture = RIGHT
	virtual_key_release(JOY_BUTTON_DPAD_RIGHT)

func on_north_pressed() -> void:
	up.texture = UP_HELD
	vibrate()
	virtual_key_press(JOY_BUTTON_DPAD_UP)

func on_north_released() -> void:
	up.texture = UP
	virtual_key_release(JOY_BUTTON_DPAD_UP)

func on_south_pressed() -> void:
	down.texture = DOWN_HELD
	vibrate()
	virtual_key_press(JOY_BUTTON_DPAD_DOWN)

func on_south_released() -> void:
	down.texture = DOWN
	virtual_key_release(JOY_BUTTON_DPAD_DOWN)

func on_b_pressed() -> void:
	b.texture = B_HELD
	vibrate()
	Input.action_press("ui_back")
	if !run_lock_on:
		Input.action_press("run_0")

func on_b_released() -> void:
	b.texture = B
	Input.action_release("ui_back")
	if !run_lock_on:
		Input.action_release("run_0")

func on_a_pressed() -> void:
	a.texture = A_HELD
	vibrate()
	Input.action_press("ui_accept")

func on_a_released() -> void:
	a.texture = A
	Input.action_release("ui_accept")

func on_run_lock_pressed() -> void:
	if run_lock_on:
		run_lock.texture = RUN_LOCK
		Input.action_release("run_0")
	else:
		run_lock.texture = RUN_LOCK_ON
		Input.action_press("run_0")
	vibrate()
	run_lock_on = !run_lock_on

#func on_run_lock_released() -> void:
#	pass # Replace with function body.

func on_start_pressed() -> void:
	start.texture = START_HELD
	vibrate()

func on_start_released() -> void:
	start.texture = START

func on_select_pressed() -> void:
	select.texture = SELECT_HELD
	vibrate()

func on_select_released() -> void:
	select.texture = SELECT

func _exit_tree():
	vibration_thread.wait_to_finish()
