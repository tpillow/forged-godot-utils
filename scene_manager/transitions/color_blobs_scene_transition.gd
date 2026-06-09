class_name ColorBlobsSceneTransition
extends SceneTransition

@export var num_iters := 50
@export var iter_duration := 0.01
@export var size_ratio_bounds := Vector2(0.25, 0.6)
@export var colors: Array[Color] = [Color.WHITE]

var _color_rects: Array[ColorRect] = []

func _ready() -> void:
	from_node.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(from_node)
	
	var tween := create_tween()
	for i in range(num_iters):
		tween.tween_callback(_spawn_rect)
		tween.tween_interval(iter_duration)
	tween.tween_callback(func(): _spawn_rect(get_viewport().get_visible_rect().size))

	tween.tween_callback(func():
		from_node.queue_free()
		to_node.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(to_node)
		move_child(to_node, 0)
		
		var tween2 := create_tween()
		_color_rects.reverse()
		for cr in _color_rects:
			tween2.tween_callback(cr.queue_free)
			tween2.tween_interval(iter_duration)

		tween2.tween_callback(func():
			remove_child(to_node)
			to_node.process_mode = Node.PROCESS_MODE_INHERIT
			completed.emit()
			queue_free())
	)

func _spawn_rect(size: Vector2 = Vector2(-1, -1)) -> void:
	var cr := ColorRect.new()
	cr.color = colors.pick_random()
	
	var view_size := get_viewport().get_visible_rect().size
	var ratio := Vector2(
		randf_range(size_ratio_bounds.x, size_ratio_bounds.y),
		randf_range(size_ratio_bounds.x, size_ratio_bounds.y))
	if size == Vector2(-1, -1):
		size = view_size * ratio
		cr.position = Vector2(
			randf_range(-size.x / 2, view_size.x - size.x / 2),
			randf_range(-size.y / 2, view_size.y - size.y / 2))
	else:
		cr.position = Vector2.ZERO
	cr.custom_minimum_size = size
	add_child(cr)
	_color_rects.append(cr)
