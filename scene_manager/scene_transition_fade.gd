class_name SceneTransitionFade
extends SceneTransition

var color: Color = Color.BLACK
var tween_settings := TweenSettings.new()

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
	tween_settings.setup_for_tween(tween)
	tween.tween_property(color_rect, "color:a", 1.0, tween_settings.duration / 2.0)
	tween.tween_callback(callback.call)
	tween.tween_property(color_rect, "color:a", 0.0, tween_settings.duration / 2.0)
	tween.tween_callback(center_container.queue_free)
