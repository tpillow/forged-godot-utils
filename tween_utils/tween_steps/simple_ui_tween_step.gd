class_name SimpleUiTweenStep
extends TweenStep

enum UiTweenType {
	SLIDE_IN_LEFT,
	SLIDE_OUT_LEFT,
	SLIDE_IN_RIGHT,
	SLIDE_OUT_RIGHT,
}

@export var ui_tween_type: UiTweenType = UiTweenType.SLIDE_IN_LEFT
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration := 1.0

func apply_tween() -> void:
	tween_anim.tween.set_ease(easing).set_trans(trans)
	
	match ui_tween_type:
		UiTweenType.SLIDE_IN_LEFT, UiTweenType.SLIDE_IN_RIGHT:
			var value: Vector2 = tween_anim.source.intial_node_prop_cache.get("position")
			tween_anim.tween.tween_property(tween_anim.source.node, "position", value, duration)
		UiTweenType.SLIDE_OUT_LEFT:
			var start: Vector2 = tween_anim.source.intial_node_prop_cache.get("position")
			var size: Vector2 = tween_anim.source.node.size
			var value := start + Vector2(-size.x, 0)
			tween_anim.tween.tween_property(tween_anim.source.node, "position", value, duration)
		UiTweenType.SLIDE_OUT_RIGHT:
			var start: Vector2 = tween_anim.source.intial_node_prop_cache.get("position")
			var size: Vector2 = tween_anim.source.node.size
			var value := start + Vector2(size.x, 0)
			tween_anim.tween.tween_property(tween_anim.source.node, "position", value, duration)
		_: assert(false)
