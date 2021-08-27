// 提取原始场景贴图中明亮的部分
// 这是应用全屏泛光效果的第一步

sampler TextureSampler : register(s0);

float BloomThreshold;

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    // 提取原有像素颜色
    float4 c = tex2D(TextureSampler, texCoord);

    // 在BloomThreshold参数基础上筛选较明亮的像素
    return saturate((c - BloomThreshold) / (1 - BloomThreshold));
    
}

technique BloomExtract
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ThePixelShader();
    }
}