class_name SimpleUiTweenStep
extends TweenStep

enum UiTweenType {
	TO_INITIAL_POS,
	SLIDE_OUT_LEFT,
	SLIDE_OUT_RIGHT,
}

@export var ui_tween_type: UiTweenType = UiTweenType.TO_INITIAL_POS
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration := 1.0

var _initial_position: Vector2
var _initial_size: Vector2

func _ready() -> void:
    _initial_position = tween_anim.source.node.position
    _initial_size = tween_anim.source.node.size

func apply_tween() -> void:
	tween_anim.tween.set_ease(easing).set_trans(trans)
	
	match ui_tween_type:
		UiTweenType.TO_INITIAL_POS:
			tween_anim.tween.tween_property(tween_anim.source.node, "position", _initial_position, duration)
		UiTweenType.SLIDE_OUT_LEFT:
			var size: Vector2 = tween_anim.source.node.size
			var offset := Vector2(-size.x, 0)
			tween_anim.tween.tween_property(tween_anim.source.node, "position", offset, duration).as_relative().from(_initial_position)
		UiTweenType.SLIDE_OUT_RIGHT:
			var size: Vector2 = tween_anim.source.node.size
			var offset := Vector2(size.x, 0)
			tween_anim.tween.tween_property(tween_anim.source.node, "position", offset, duration).as_relative().from(_initial_position)
		_: assert(false)

    tween_anim.tween.tween_callback(completed.emit)

