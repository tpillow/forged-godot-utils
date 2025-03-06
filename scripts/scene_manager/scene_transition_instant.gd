class_name SceneTransitionInstant
extends SceneTransition

func _init(scene_manager: SceneManager) -> void:
	super(scene_manager)

func begin(action: Callable) -> void:
	action.call()
