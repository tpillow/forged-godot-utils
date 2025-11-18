@tool
class_name DrawCircleControl
extends Control

@export var radius := 10.0:
	get: return radius
	set(value):
		radius = value
		_refresh()

@export var line_color := Color.BLACK:
	get: return line_color
	set(value):
		line_color = value
		_refresh()
		
@export var line_width := 1.0:
	get: return line_width
	set(value):
		line_width = value
		_refresh()

@export var fill_color := Color.TRANSPARENT:
	get: return fill_color
	set(value):
		fill_color = value
		_refresh()

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if !is_node_ready():
		return
	size = Vector2.ZERO
	queue_redraw()

func _draw() -> void:
	if fill_color != Color.TRANSPARENT:
		draw_circle(Vector2.ZERO, radius, fill_color, true)
	draw_circle(Vector2.ZERO, radius, line_color, false, line_width)
