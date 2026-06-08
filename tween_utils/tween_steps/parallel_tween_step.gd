class_name ParallelTweenStep
extends TweenStep

func apply_tween() -> void:
    # TODO: not call parallel on first tween?
	for ts in NodeUtil.find_all_children_of_type(self, TweenStep, false):
		tween_anim.tween.parallel()
		ts.apply_tween()
    tween_anim.tween.tween_callback(completed.emit)
