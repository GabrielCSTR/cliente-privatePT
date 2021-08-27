sampler ColorSampler1 : register(s0);

#define SAMPLE_SIZE 15

float2 texelSize;
float offsets[SAMPLE_SIZE];
float weights[SAMPLE_SIZE];

float4 PS_BlurH(float2 texCoord : TEXCOORD0) : COLOR0
{
	float4 sum = float4(0.0, 0.0, 0.0, 1.0);
	
	for (int i = 0; i < SAMPLE_SIZE; i++)
		sum += tex2D(ColorSampler1, float2(texCoord.x + (offsets[i] * texelSize.x), texCoord.y)) * weights[i];
	
	clip(sum.a < 0.01f ? -1 : 1);
	
	return sum;
}

float4 PS_BlurV(float2 texCoord : TEXCOORD0) : COLOR0
{
	float4 sum = float4(0.0, 0.0, 0.0, 1.0);
	
	for (int i = 0; i < SAMPLE_SIZE; i++)
		sum += tex2D(ColorSampler1, float2(texCoord.x, texCoord.y + (offsets[i] * texelSize.y))) * weights[i];
	
	clip(sum.a < 0.01f ? -1 : 1);
	
	return sum;
}

technique Glow
{
	pass BlurHorizontal
	{
		PixelShader = compile ps_2_0 PS_BlurH();
	}
	
	pass BlurVertical
	{
		PixelShader = compile ps_2_0 PS_BlurV();
	}
}