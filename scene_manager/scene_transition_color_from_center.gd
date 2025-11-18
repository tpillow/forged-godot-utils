class_name SceneTransitionColorFromCenter
extends SceneTransition

var color: Color = Color.WHITE
var trans_type_in: Tween.TransitionType = Tween.TRANS_BOUNCE
var ease_type_in: Tween.EaseType = Tween.EASE_OUT
var duration_in := 0.8
var trans_type_out: Tween.TransitionType = Tween.TRANS_EXPO
var ease_type_out: Tween.EaseType = Tween.EASE_OUT
var duration_out := duration_in / 2.0

func begin(manager: SceneManager, type: Type, new_scene: Node) -> void:
	_start_tween(manager, func():
		SceneTransitionInstant.begin_static(manager, type, new_scene))

func _start_tween(manager: SceneManager, callback: Callable) -> void:
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var color_rect = ScreenPercentageColorRect.new()
	color_rect.color = color
	color_rect.size_percent = 0.0
	center_container.add_child(color_rect)
	manager._overlays_container.add_child(center_container)
	
	var tween := manager.create_tween()
	tween.set_trans(trans_type_in).set_ease(ease_type_in)
	tween.tween_property(color_rect, "size_percent", 1.0, duration_in)
	tween.tween_callback(callback.call)
	tween.set_trans(trans_type_out).set_ease(ease_type_out)
	tween.tween_property(color_rect, "size_percent", 0.0, duration_out)
	tween.tween_callback(center_container.queue_free)
