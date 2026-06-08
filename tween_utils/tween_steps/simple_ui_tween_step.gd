class_name SimpleUiTweenStep
extends TweenStep

enum UiTweenType {
	TO_INITIAL_POS,
    TO_OFF_SCREEN_DIR,
}

@export var ui_tween_type: UiTweenType = UiTweenType.TO_INITIAL_POS
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration := 1.0

# TODO: make proper dir enum and use here
@export var off_screen_dir := Vector2i.LEFT

var source_view_size: Vector2:
    get: return tween_anim.source.node.get_viewport().get_visible_rect().size

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
		UiTweenType.TO_OFF_SCREEN_DIR:
			assert(off_screen_dir != Vector2i.ZERO)

            var pos: Vector2 = tween_anim.source.node.position
			var size: Vector2 = tween_anim.source.node.size

			var xp := -size.x if off_screen_dir.x < 0 else ( source_view_size.x if off_screen_dir.x > 0 else pos.x )
			var yp := -size.y if off_screen_dir.y < 0 else ( source_view_size.y if off_screen_dir.y > 0 else pos.y )
			var end_value := Vector2(xp, yp)

			tween_anim.tween.tween_property(tween_anim.source.node, "position", end_value, duration)
		_: assert(false)

    tween_anim.tween.tween_callback(completed.emit)

