@abstract
class_name SceneTransition
extends Object

enum Type {
	PUSH,
	POP,
	REPLACE,
	REPLACE_ALL,
}

@abstract func begin(manager: SceneManager, type: Type, new_scene: Node) -> void
