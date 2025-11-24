class_name SceneTransitionColorFromCenter
extends SceneTransition

var color: Color = Color.WHITE
var tween_settings_in := TweenSettings.new_with(Tween.EASE_OUT, Tween.TRANS_BOUNCE, 0.8)
var tween_settings_out := TweenSettings.new_with(Tween.EASE_OUT, Tween.TRANS_EXPO, 0.4)

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
	tween_settings_in.setup_for_tween(tween)
	tween.tween_property(color_rect, "size_percent", 1.0, tween_settings_in.duration)
	tween.tween_callback(callback.call)
	tween_settings_out.setup_for_tween(tween)
	tween.tween_property(color_rect, "size_percent", 0.0, tween_settings_out.duration)
	tween.tween_callback(center_container.queue_free)
