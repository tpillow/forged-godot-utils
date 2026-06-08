class_name ParallelTweenStep
extends TweenStep

func apply_tween() -> void:
    var apply_parallel := false
	for ts in NodeUtil.find_all_children_of_type(self, TweenStep, false):
		if apply_parallel:
			tween_anim.tween.parallel()
		else:
			apply_parallel = true
		ts.apply_tween()
    tween_anim.tween.tween_callback(completed.emit)
