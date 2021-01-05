/*
	Composes UI with postprocessed scene
	by megai2
*/

#include "ReShade.fxh"

texture ui_overlay
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	Format = RGBA8;
};
sampler	smp_ui_overlay { Texture = ui_overlay; };

texture scene_color : CROSSTALK_COLOR;
sampler	smp_scene_color { Texture = scene_color; };

void PS_ComposeUI(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target)
{		
	float4 bb_pixel = tex2D(ReShade::BackBuffer, texcoord);
	float4 ui_pixel = tex2D(smp_ui_overlay, texcoord);
	float4 src_pixel = tex2D(smp_scene_color, texcoord);
	float4 result = ui_pixel - (1.0f - ui_pixel.w) * (src_pixel - bb_pixel);
	color.xyz = result.xyz;
	
}

technique ComposeUI <
	ui_tooltip = "Composes UI with postprocessed scene \n" 
		"Game should provide 3d scene color by ReShade API \n"
		"Must be used with SceneColorToBB";
>

{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_ComposeUI;
	}
}
