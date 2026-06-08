class_name ParallelTweenStep
extends TweenStep

func apply_tween() -> void:
	for ts in NodeUtil.find_all_children_of_type(self, TweenStep, false):
		tween_anim.tween.parallel()
		ts.apply_tween()
