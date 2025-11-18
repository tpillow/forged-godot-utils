class_name ScreenPercentageColorRect
extends Control

@export var color: Color:
	get: return color
	set(value):
		color = value
		_refresh()

@export var size_percent := 1.0:
	get: return size_percent
	set(value):
		size_percent = clamp(value, 0.0, 1.0)
		_refresh()

func _ready() -> void:
	size_percent = size_percent

func _refresh() -> void:
	custom_minimum_size = DisplayServer.window_get_size() * size_percent
	queue_redraw()

func _draw() -> void:
	if size_percent <= 0:
		return
		
	draw_rect(Rect2(Vector2.ZERO, size), color, true)
