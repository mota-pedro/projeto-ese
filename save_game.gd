extends Node

const SAVE_PATH = "user://save.cfg"

var recorde_fase: int = 0  # começa como 0 = nenhum recorde

func _ready():
	carregar()

func salvar(fase: int):
	if fase > recorde_fase:
		recorde_fase = fase
	var config = ConfigFile.new()
	config.set_value("progresso", "recorde_fase", recorde_fase)
	config.save(SAVE_PATH)

func carregar():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		recorde_fase = config.get_value("progresso", "recorde_fase", 0)
