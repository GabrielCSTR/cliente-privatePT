sampler TexSampler : register(s0);

float fAlpha = 0.255f;


float4 PS_Base( float2 Tex : TEXCOORD0 ) : COLOR
{
	float4 Color = tex2D(TexSampler, Tex);
	Color.r *= 2;
	return Color;
}

technique Base
{
	pass Pass1
	{	
		AlphaBlendEnable = TRUE;	
		PixelShader  = compile ps_2_0 PS_Base(); 	
	}
}