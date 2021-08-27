sampler TexSampler : register(s0)
{
    MagFilter = Point;
    MinFilter = Point;
    AddressU = Wrap;
    AddressV = Wrap;
};

texture MaskTexture;

sampler2D MaskTextureSampler = sampler_state
{
    Texture   = <MaskTexture>;
    MinFilter = Point;
    MagFilter = Point;
};

float4 PS_MaskScale( float2 Tex : TEXCOORD0 ) : COLOR
{
 float4 Color = tex2D(TexSampler, Tex);
 float4 Mask = tex2D(MaskTextureSampler, Tex);

 Color.a *= Mask.a;

 return Color;
}

technique MaskScale
{
	pass Pass1
	{	
		AlphaBlendEnable = TRUE;	
		PixelShader  = compile ps_2_0 PS_MaskScale(); 	
	}
}