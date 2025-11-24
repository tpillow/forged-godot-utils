@tool
class_name BasicTextOptionDialogue
extends PanelContainer

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

static var show_dialogue_scene_manager: SceneManager = null
static var show_dialogue_scene_transition: SceneTransition = SceneTransitionInstant.new()
static var show_dialogue_min_size := Vector2(600, 300)
static var show_dialogue_default_footer := ""

static func instantiate_new() -> BasicTextOptionDialogue:
	return preload("res://forged_godot_utils/ui_nodes/basic_text_option_dialogue.tscn").instantiate()

static func instantiate_new_basic_menu(
		header: String,
		sub_header: String,
		options: Array[String],
		footer: String) -> BasicTextOptionDialogue:
	var dialogue := preload("res://forged_godot_utils/ui_nodes/basic_menu_screen.tscn").instantiate()
	dialogue.header = header
	dialogue.content = sub_header
	dialogue.options = options
	dialogue.footer = footer
	return dialogue

static func show_dialogue(
		header: String,
		content: String,
		options: Array[String] = [],
		footer: String = show_dialogue_default_footer) -> int:
	var dialogue := instantiate_new()
	dialogue.header = header
	dialogue.content = content
	dialogue.options = options
	dialogue.footer = footer
	dialogue.custom_minimum_size = show_dialogue_min_size
	
	var container := CenterContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(dialogue)
	
	show_dialogue_scene_manager.push_ui(container, show_dialogue_scene_transition)
	var selected_option: int = await dialogue.option_selected
	show_dialogue_scene_manager.pop(show_dialogue_scene_transition)
	return selected_option

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
