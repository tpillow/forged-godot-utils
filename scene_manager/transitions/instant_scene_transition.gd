class_name InstantSceneTransition
extends SceneTransition

func _ready() -> void:
	completed.emit()
	queue_free()
