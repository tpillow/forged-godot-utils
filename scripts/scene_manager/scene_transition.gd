class_name SceneTransition
extends Object

var _scene_manager: SceneManager

func _init(scene_manager: SceneManager) -> void:
    _scene_manager = scene_manager

func begin(action: Callable) -> void:
    assert(false)
	
class SceneTransitionInstant extends SceneTransition:
	func _init(scene_manager: SceneManager) -> void:
		super(scene_manager)
	
    func begin(action: Callable) -> void:
        action.call()