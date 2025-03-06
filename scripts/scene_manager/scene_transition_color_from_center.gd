class_name SceneTransitionColorFromCenter
extends SceneTransition

var color: Color = Color.WHITE
var trans_type_in: Tween.TransitionType = Tween.TRANS_BOUNCE
var ease_type_in: Tween.EaseType = Tween.EASE_OUT
var duration_in := 0.3
var trans_type_out: Tween.TransitionType = Tween.TRANS_EXPO
var ease_type_out: Tween.EaseType = Tween.EASE_OUT
var duration_out := 0.1

var _tween: Tween

func _init(scene_manager: SceneManager) -> void:
	super(scene_manager)

func begin(action: Callable) -> void:
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var color_rect = ScreenPercentageColorRect.new()
	color_rect.color = color
	color_rect.size_percent = 0.0
	center_container.add_child(color_rect)
	_scene_manager.overlays_container.add_child(center_container)
	
	_tween = _scene_manager.create_tween()
	_tween.set_trans(trans_type_in).set_ease(ease_type_in)
	_tween.tween_property(color_rect, "size_percent", 1.0, duration_in)
	_tween.tween_callback(action.call)
	_tween.set_trans(trans_type_out).set_ease(ease_type_out)
	_tween.tween_property(color_rect, "size_percent", 0.0, duration_out)
	_tween.tween_callback(center_container.queue_free)
