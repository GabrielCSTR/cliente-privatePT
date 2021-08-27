// 高斯模糊过滤
// 这个特效要应用两次，一次为横向模糊，另一次为横向模糊基础上的纵向模糊，以减少算法上的时间复杂度
// 这是应用Bloom特效的中间步骤

sampler TextureSampler : register(s0);

#define SAMPLE_COUNT 15

// 偏移数组
float2 SampleOffsets[SAMPLE_COUNT];
// 权重数组
float SampleWeights[SAMPLE_COUNT];

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 c = 0;
    
    // 按偏移及权重数组叠加周围颜色值到该像素
    // 相对原理，即可理解为该像素颜色按特定权重发散到周围偏移像素
    for (int i = 0; i < SAMPLE_COUNT; i++)
    {
        c += tex2D(TextureSampler, texCoord + SampleOffsets[i]) * SampleWeights[i];
    }
    
    return c;
}

technique GaussianBlur
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ThePixelShader();
    }
}