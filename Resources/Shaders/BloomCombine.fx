// 按照特定比例混合原始场景贴图及高斯模糊贴图，产生泛光效果
// 这是全屏泛光特效的最后一步

// 模糊场景纹理采样器
sampler BloomSampler : register(s0);

// 原始场景纹理及采样器定义
texture BaseTexture;
sampler BaseSampler = sampler_state
{
    Texture   = (BaseTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

float BloomIntensity;
float BaseIntensity;

float BloomSaturation;
float BaseSaturation;

// 减缓颜色的饱和度
float4 AdjustSaturation(float4 color, float saturation)
{
    // 人眼更喜欢绿光，因此选取0.3, 0.59, 0.11三个值
    float grey = dot(color, float3(0.3, 0.59, 0.11));
    return lerp(grey, color, saturation);
}

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    // 提取原始场景贴图及模糊场景贴图的像素颜色
    float4 bloom = tex2D(BloomSampler, texCoord);
    float4 base = tex2D(BaseSampler, texCoord);
    
    // 柔化原有像素颜色
    bloom = AdjustSaturation(bloom, BloomSaturation) * BloomIntensity;
    base = AdjustSaturation(base, BaseSaturation) * BaseIntensity;
    
    // 结合模糊像素值微调原始像素值
    base *= (1 - saturate(bloom));
    
    // 叠加原始场景贴图及模糊场景贴图，即在原有像素基础上叠加模糊后的像素，实现发光效果
    return base + bloom;
}

technique BloomCombine
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ThePixelShader();
    }
}