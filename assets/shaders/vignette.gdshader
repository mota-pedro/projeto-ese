shader_type canvas_item;

// Intensidade do vignette: 0.0 = sem efeito, 1.0 = bordas bem escuras.
// Controlado em runtime pelo hud.gd conforme a saúde mental do jogador.
uniform float strength : hint_range(0.0, 1.0) = 0.0;

// Onde o escurecimento começa/termina (em relação ao centro da tela).
uniform float radius : hint_range(0.0, 1.5) = 0.75;
uniform float softness : hint_range(0.01, 1.5) = 0.55;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = UV - vec2(0.5);
	// normaliza para que os cantos da tela cheguem perto de 1.0
	float dist = length(uv) * 1.4142135;
	float vig = smoothstep(radius - softness, radius, dist);
	COLOR = vec4(vignette_color.rgb, vig * strength);
}
