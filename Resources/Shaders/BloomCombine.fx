// �����ض��������ԭʼ������ͼ����˹ģ����ͼ����������Ч��
// ����ȫ��������Ч�����һ��

// ģ���������������
sampler BloomSampler : register(s0);

// ԭʼ������������������
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

// ������ɫ�ı��Ͷ�
float4 AdjustSaturation(float4 color, float saturation)
{
    // ���۸�ϲ���̹⣬���ѡȡ0.3, 0.59, 0.11����ֵ
    float grey = dot(color, float3(0.3, 0.59, 0.11));
    return lerp(grey, color, saturation);
}

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    // ��ȡԭʼ������ͼ��ģ��������ͼ��������ɫ
    float4 bloom = tex2D(BloomSampler, texCoord);
    float4 base = tex2D(BaseSampler, texCoord);
    
    // �ữԭ��������ɫ
    bloom = AdjustSaturation(bloom, BloomSaturation) * BloomIntensity;
    base = AdjustSaturation(base, BaseSaturation) * BaseIntensity;
    
    // ���ģ������ֵ΢��ԭʼ����ֵ
    base *= (1 - saturate(bloom));
    
    // ����ԭʼ������ͼ��ģ��������ͼ������ԭ�����ػ����ϵ���ģ��������أ�ʵ�ַ���Ч��
    return base + bloom;
}

technique BloomCombine
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ThePixelShader();
    }
}