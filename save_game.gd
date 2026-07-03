extends Node

const SAVE_PATH = "user://save.cfg"

var recorde_fase: int = 0     # começa como 0 = nenhum recorde
var tutorial_visto: bool = false  # true depois que o jogador vê a ajuda pela 1ª vez

func _ready():
	carregar()

func salvar(fase: int):
	if fase > recorde_fase:
		recorde_fase = fase
	_salvar_config()

func marcar_tutorial_visto():
	if tutorial_visto:
		return
	tutorial_visto = true
	_salvar_config()

func _salvar_config():
	var config = ConfigFile.new()
	config.set_value("progresso", "recorde_fase", recorde_fase)
	config.set_value("progresso", "tutorial_visto", tutorial_visto)
	config.save(SAVE_PATH)

func carregar():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		recorde_fase = config.get_value("progresso", "recorde_fase", 0)
		tutorial_visto = config.get_value("progresso", "tutorial_visto", false)
