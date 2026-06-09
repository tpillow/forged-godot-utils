class_name FadeSceneTransition
extends SceneTransition

@export var single_fade_duration := 1.0
@export var mid_pause_duration := 0.2
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var from_color := Color(0, 0, 0, 0)
@export var to_color := Color(0, 0, 0, 1)

func _ready() -> void:
	from_node.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(from_node)

	var cr := ColorRect.new()
	add_child(cr)
	cr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var tween := create_tween()
	tween.set_ease(easing).set_trans(trans)
	tween.tween_property(cr, "color", to_color, single_fade_duration).from(from_color)
	tween.tween_interval(mid_pause_duration)

	tween.tween_callback(func():
		from_node.queue_free()
		to_node.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(to_node)
		move_child(to_node, 0))
		
	tween.tween_property(cr, "color", from_color, single_fade_duration)
	tween.tween_callback(func():
		remove_child(to_node)
		to_node.process_mode = Node.PROCESS_MODE_INHERIT
		completed.emit()
		queue_free())
