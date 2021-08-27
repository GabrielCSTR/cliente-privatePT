float Time = 0.0f;

float DeadIntensity = 1.0f;

//Hdr Effects, 0.0f to 8.0f
float HDRPower = 0.87f; //Default: 1.30f
float radius1 = 0.793f; //Default: 0.793f
float radius2 = 0.86f;  //Default: 0.87f

float PixelSize = 0.75f;

sampler ColorSampler : register(s0);

float4 PS_BattleRoyaleGas(float2 texCoord : TEXCOORD0) : COLOR0
{
	texCoord.y = texCoord.y + (sin((texCoord.x*2.0f)+(Time / 4.0f))*0.01f);
	texCoord.x = texCoord.x + (cos(0.5f)*0.01f);

	float4 Color = tex2D(ColorSampler, texCoord); 
	Color.r *= 0.75f;
	Color.g *= 0.75f;

	return Color;
}

float4 PS_Poison(float2 texCoord : TEXCOORD0) : COLOR0
{
	texCoord.y = texCoord.y + (sin((texCoord.x*8.0f)+Time)*0.01f);
	texCoord.x = texCoord.x + (cos(0.5f)*0.01f);

	float4 Color = tex2D(ColorSampler, texCoord); 
	Color += tex2D(ColorSampler, texCoord + float2(0.002f, 0.0f));
	Color += tex2D(ColorSampler, texCoord + float2(0.004f, 0.0f));

	return Color/3;
}

float4 PS_Dead(float2 texCoord : TEXCOORD0) : COLOR0
{
	float2 t = texCoord;

	//Noise
	float x = t.x * t.y * 1000 * Time;
	x = fmod(x, 135) * fmod(x, 1234);

	//Noise
	float dx = fmod(x, 0.0021f * DeadIntensity);
	float dy = fmod(x, 0.0023f * DeadIntensity);

	//Pick Noised Color
	float4 Color = tex2D(ColorSampler, t + float2(dx, dy));
	float4 BaseColor = Color;

	//Gray
	Color.rgb = dot(Color.rgb, float3(0.3f, 0.59f, 0.11f));

	//Cyan color
	Color.r = max(0.0f, Color.r - 0.1f);

	//Intensity of Cyan color
	Color *= (DeadIntensity * 2.0f).xxxx;

	//Intensiry of Base Color
	BaseColor *= (2.0f - (DeadIntensity * 2.0f)).xxxx;

	//Average between Colors
	Color = (Color + BaseColor) / 2;

	return Color;
}

float4 HDRPass(float2 texcoord : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(ColorSampler, texcoord);

	float4 bloom_sum1 = tex2D(ColorSampler, texcoord + float2(1.5, -1.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2(-1.5, -1.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2( 1.5,  1.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2(-1.5,  1.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2( 0.0, -2.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2( 0.0,  2.5) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2(-2.5,  0.0) * radius1 * PixelSize);
	bloom_sum1 += tex2D(ColorSampler, texcoord + float2( 2.5,  0.0) * radius1 * PixelSize);

	bloom_sum1 *= 0.005;

	float4 bloom_sum2 = tex2D(ColorSampler, texcoord + float2(1.5, -1.5) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2(-1.5, -1.5) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2( 1.5,  1.5) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2(-1.5,  1.5) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2( 0.0, -2.5) * radius2 * PixelSize);	
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2( 0.0,  2.5) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2(-2.5,  0.0) * radius2 * PixelSize);
	bloom_sum2 += tex2D(ColorSampler, texcoord + float2( 2.5,  0.0) * radius2 * PixelSize);

	bloom_sum2 *= 0.010;

	float dist = radius2 - radius1;
	float4 HDR = (color + (bloom_sum2 - bloom_sum1)) * dist;
	float4 blend = HDR + color;
	color = pow(abs(blend), abs(HDRPower)) + HDR; // pow - don't use fractions for HDRpower
	
	return saturate(color);
}


technique BattleRoyaleGas
{
	pass Pass1
	{
		ZEnable = FALSE;
		AlphaBlendEnable = FALSE;
		PixelShader = compile ps_2_0 PS_BattleRoyaleGas();
	}
}

technique Poison
{
	pass Pass1
	{
		ZEnable = FALSE;
		AlphaBlendEnable = FALSE;
		PixelShader = compile ps_2_0 PS_Poison();
	}
}

technique Dead
{
	pass Pass1
	{
		ZEnable = FALSE;
		AlphaBlendEnable = FALSE;
		PixelShader = compile ps_2_0 PS_Dead();
	}
}

technique FakeHDR
{
	pass Pass1
	{
		ZEnable = FALSE;
		AlphaBlendEnable = FALSE;
		PixelShader = compile ps_2_0 HDRPass();
	}
}
