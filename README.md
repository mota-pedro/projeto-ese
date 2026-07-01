# 🧠 Jogo — Saúde Mental nas Redes Sociais
**Projeto ESE — Godot 4.x**

---

## Como abrir no Godot

1. Baixe e instale o [Godot 4](https://godotengine.org/download)
2. Abra o Godot → **Import** → selecione a pasta `jogo-saude-mental/`
3. Clique em `project.godot` → **Import & Edit**
4. Pressione **F5** (ou o botão ▶) para rodar

---

## Mecânica do Jogo

| Elemento | Efeito |
|---|---|
| 🟥 **Post negativo** | Diminui -2 de saúde mental |
| 🟩 **Post positivo** | Recupera +2 de saúde mental |
| ⏱️ **Timer** | 60 segundos para sobreviver |
| 💀 **Saúde = 0** | Game Over |
| ✅ **Timer = 0** | Vitória! |

**Controles:** `Espaço` ou `↑` para pular

---

## Arquivos do Projeto

| Arquivo | Função |
|---|---|
| `character_body_2d.gd` | Player: pulo, dano, cura, invencibilidade |
| `game_manager.gd` | Timer de 60s e condição de vitória/derrota |
| `hud.gd` | Barra de saúde mental colorida + feedback dos posts |
| `post.gd` | Post de rede social (positivo ou negativo) com texto temático |
| `post.tscn` | Cena visual do post (CartãoColorido + Label + HitBox) |
| `obstacle_spawner.gd` | Spawna posts aleatórios com dificuldade crescente |
| `main.gd` | Orquestrador: conecta todos os sistemas |
| `primeira_fase.tscn` | Cena principal com todos os nós |

---

## Textos dos Posts (baseados no levantamento do tema)

### Posts Negativos (estigmas)
- "Só os bonitos têm sucesso 😈"
- "Você não é bom o suficiente 💔"
- "Todo mundo está se divertindo menos você 😒"
- "Seu corpo não está no padrão 😬"
- "Sem likes = sem valor 👎"
- ... e mais 5 variações

### Posts Positivos (mensagens de apoio)
- "Você não precisa ser perfeito 💚"
- "Likes não definem seu valor 💛"
- "Cuide da sua saúde mental 🧠"
- "Você é suficiente do jeito que é ✨"
- "Peça ajuda quando precisar 🤝"
- ... e mais 5 variações

---

## Próximos Passos Sugeridos

- [ ] Substituir `icon.svg` pelo sprite real do personagem
- [ ] Adicionar background/cenário (rua, escola, quarto)
- [ ] Tela de início com instruções
- [ ] Tela de fim com mensagem educativa
- [ ] Sons: trilha sonora + efeitos ao coletar posts
- [ ] Animações do personagem (corrida, pulo, dano)
