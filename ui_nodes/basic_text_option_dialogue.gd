@tool
class_name BasicTextOptionDialogue
extends PanelContainer

signal acknowledged()
signal option_selected(index: int)

@export var header := "Header":
	get: return header
	set(value):
		header = value
		_refresh()
@export var content := "This is content!":
	get: return content
	set(value):
		content = value
		_refresh()
@export var options: Array[String] = ["Option A", "Option B"]:
	get: return options
	set(value):
		options = value
		_refresh()
@export var footer := "Footer":
	get: return footer
	set(value):
		footer = value
		_refresh()

@onready var header_label: RichTextLabel = %HeaderLabel
@onready var content_label: RichTextLabel = %ContentLabel
@onready var options_list: SelectableTextItemList = %OptionsList
@onready var footer_label: RichTextLabel = %FooterLabel

static func instantiate_new() -> BasicTextOptionDialogue:
	return preload("res://forged_godot_utils/ui_nodes/basic_text_option_dialogue.tscn").instantiate()

func _ready() -> void:
	options_list.option_selected.connect(option_selected.emit)
	_refresh()

func _refresh() -> void:
	if not is_node_ready():
		return

	header_label.text = header
	header_label.visible = header != ""
	content_label.text = content
	options_list.options = options
	options_list.visible = options.size() > 0
	footer_label.text = footer
	footer_label.visible = footer != ""

func _unhandled_input(event: InputEvent) -> void:
	if options_list.options.size() > 0:
		return

	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			acknowledged.emit()
