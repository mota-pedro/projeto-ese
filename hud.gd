extends CanvasLayer

@onready var timer_label = $TimerLabel
@onready var life_label = $LifeLabel
@onready var message_label = $MessageLabel

func _ready():
	message_label.visible = false

func update_timer(formatted_time: String):
	timer_label.text = formatted_time

func update_life(current_health: int, max_health: int):
	life_label.text = "Vida: %d/%d" % [current_health, max_health]

func show_message(text: String):
	message_label.text = text
	message_label.visible = true
