sampler TexSampler : register(s0)
{
    MagFilter = Point;
    MinFilter = Point;
    AddressU = Wrap;
    AddressV = Wrap;
};

float4 PS_MaskBox( float2 Tex : TEXCOORD0 ) : COLOR
{
    	float4 color = tex2D(TexSampler, Tex);

	bool bCut = false;
	if( color.r == 0 && color.g == 0 && color.b == 0 )
		bCut = true;

	clip( bCut ? -1 : 1 );

	return color;
}

technique Mask
{
	pass Pass1
	{	
		AlphaBlendEnable = TRUE;	
		PixelShader  = compile ps_2_0 PS_MaskBox(); 	
	}
}