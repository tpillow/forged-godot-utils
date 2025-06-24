class_name SceneTransitionFade
extends SceneTransition

var color: Color = Color.BLACK
var trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
var ease_type: Tween.EaseType = Tween.EASE_OUT
var duration := 0.6

func begin(manager: SceneManager, type: Type, new_scene: Node) -> void:
	_start_tween(manager, func():
		SceneTransitionInstant.begin_static(manager, type, new_scene))

func _start_tween(manager: SceneManager, callback: Callable) -> void:
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var color_rect = ScreenPercentageColorRect.new()
	color_rect.color = color
	color_rect.color.a = 0.0
	color_rect.size_percent = 1.0
	center_container.add_child(color_rect)
	manager._overlays_container.add_child(center_container)
	
	var tween := manager.create_tween()
	tween.set_trans(trans_type).set_ease(ease_type)
	tween.tween_property(color_rect, "color:a", 1.0, duration / 2.0)
	tween.tween_callback(callback.call)
	tween.tween_property(color_rect, "color:a", 0.0, duration / 2.0)
	tween.tween_callback(center_container.queue_free)
