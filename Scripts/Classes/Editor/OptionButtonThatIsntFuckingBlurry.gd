class_name BetterOptionButton
extends OptionButton

## SO. AS GODOT IS THE BIGGEST LOAD OF SHIT, ITS POPUP MENUS ARE FILTERED, AS SEEN HERE
## https://github.com/godotengine/godot/issues/103552
## EVEN THOUGH, ITS MARKED AS FIXED AND COMPLETE, IT CLEARLY FUCKING ISNT, SO I HAVE TO USE
## THIS BULLSHIT, TO MAKE IT NOT BLURRY.

func _ready() -> void:
	get_popup().get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	get_popup().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
