class_name SceneTransitionInstant
extends SceneTransition

func begin(manager: SceneManager, type: Type, new_scene: Node) -> void:
	begin_static(manager, type, new_scene)

static func begin_static(manager: SceneManager, type: Type, new_scene: Node) -> void:
	match type:
		SceneTransition.Type.PUSH:
			if manager.top_scene:
				manager._disable_top_scene()
			manager._push_scene(new_scene)
		SceneTransition.Type.POP:
			manager._pop_scene()
			if manager.top_scene:
				manager._enable_top_scene()
		SceneTransition.Type.REPLACE:
			manager._pop_scene()
			manager._push_scene(new_scene)
		SceneTransition.Type.REPLACE_ALL:
			manager._pop_all_scenes()
			manager._push_scene(new_scene)
		_: assert(false)
