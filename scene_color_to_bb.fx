/*
  writes game 3d scene color to back buffer
  saves current back buffer to ui overlay rt
  by megai2
*/

#include "ReShade.fxh"

texture ui_overlay
{
	Width = BUFFER_WIDTH;
	Height = BUFFER_HEIGHT;
	Format = RGBA8;
};

texture scene_color : CROSSTALK_COLOR;
sampler	smp_scene_color { Texture = scene_color; };


//backup UI overlay from BB
void PS_SceneColorToBB_P1(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, 
	out float4 color : SV_Target)
{
	color = tex2D(ReShade::BackBuffer, texcoord).xyzw;
}

//write 3d scene color to BB
void PS_SceneColorToBB_P2(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, 
	out float4 color : SV_Target)
{
	color = tex2D(smp_scene_color, texcoord).xyz;
	color.w = 1.0f;
}

technique SceneColorToBB <
	ui_tooltip = "Writes game 3d scene color to back buffer \n"
		     "Game should provide 3d scene color by ReShade API\n"
			 "Back buffer should contain UI transparency mask in alpha channel";
			 
>
{
	pass
	{
		RenderTarget = ui_overlay;
		VertexShader = PostProcessVS;
		PixelShader = PS_SceneColorToBB_P1;
	}
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_SceneColorToBB_P2;
	}	
}
