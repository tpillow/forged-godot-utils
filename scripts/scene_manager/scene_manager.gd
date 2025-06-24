class_name SceneManager
extends Node

var TRANS_INSTANT := SceneTransitionInstant.new()
var TRANS_COLOR_FROM_CENTER := SceneTransitionColorFromCenter.new()
var TRANS_FADE := SceneTransitionFade.new()

var _scenes_container: Node
var _overlays_container: Node

var top_scene: Node:
	get: return (
		_scenes_container.get_child(-1)
		if _scenes_container.get_child_count() > 0
		else null )
	
func _ready() -> void:
	_scenes_container = Node.new()
	get_parent().add_child.call_deferred(_scenes_container)
	_overlays_container = Node.new()
	get_parent().add_child.call_deferred(_overlays_container)

func _pop_all_scenes(free: bool = true) -> Array[Node]:
	var ret: Array[Node] = []
	while top_scene:
		ret.append(_pop_scene(free))
	return ret
	
func _pop_scene(free: bool = true) -> Node:
	var scene := top_scene
	assert(scene)
	scene.get_parent().remove_child(scene)
	if free:
		scene.queue_free()
	return scene
	
func _push_scene(scene: Node) -> void:
	_scenes_container.add_child(scene)

func _disable_top_scene() -> void:
	assert(top_scene)
	top_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
func _enable_top_scene() -> void:
	assert(top_scene)
	top_scene.process_mode = Node.PROCESS_MODE_INHERIT
	
func replace_all(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.REPLACE_ALL, new_scene)
	
func replace(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.REPLACE, new_scene)
	
func push(new_scene: Node, transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.PUSH, new_scene)
	
func pop(transition: SceneTransition) -> void:
	transition.begin(self, SceneTransition.Type.POP, null)
