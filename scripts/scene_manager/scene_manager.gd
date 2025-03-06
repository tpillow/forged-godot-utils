class_name SceneManager
extends Node

var TRANS_INSTANT: SceneTransition
var TRANS_COLOR_FROM_CENTER: SceneTransition

var _scene_stack: Array[Node] = []
var _scenes_container: Node
var overlays_container: Node

var top_scene: Node:
	get: return _scene_stack.front() if not _scene_stack.is_empty() else null
	
func _ready() -> void:
	_scenes_container = Node.new()
	get_tree().root.add_child.call_deferred(_scenes_container)
	overlays_container = Node.new()
	get_tree().root.add_child.call_deferred(overlays_container)
	
	TRANS_INSTANT = SceneTransitionInstant.new(self)
	TRANS_COLOR_FROM_CENTER = SceneTransitionColorFromCenter.new(self)

func _pop_all() -> void:
	for scene in _scene_stack:
		scene.queue_free()
	_scene_stack.clear()

func _pop() -> void:
	var scene: Node = _scene_stack.pop_front()
	scene.queue_free()
	
	if top_scene:
		top_scene.process_mode = Node.PROCESS_MODE_INHERIT
		
func _maybe_set_top_scene_disabled() -> void:
	if top_scene:
		top_scene.process_mode = Node.PROCESS_MODE_DISABLED
		
func _push(scene: Node) -> void:
	_maybe_set_top_scene_disabled()
	_scene_stack.push_front(scene)
	scene.process_mode = Node.PROCESS_MODE_INHERIT
	_scenes_container.add_child.call_deferred(scene)
	
func replace(new_scene: Node, transition: SceneTransition) -> void:
	_maybe_set_top_scene_disabled()
	transition.begin(func():
		if top_scene:
			_pop()
		_push(new_scene))
	
func push(new_scene: Node, transition: SceneTransition) -> void:
	_maybe_set_top_scene_disabled()
	transition.begin(func():
		_push(new_scene))
	
func pop(transition: SceneTransition) -> void:
	transition.begin(_pop)
