// ��ȡԭʼ������ͼ�������Ĳ���
// ����Ӧ��ȫ������Ч���ĵ�һ��

sampler TextureSampler : register(s0);

float BloomThreshold;

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    // ��ȡԭ��������ɫ
    float4 c = tex2D(TextureSampler, texCoord);

    // ��BloomThreshold����������ɸѡ������������
    return saturate((c - BloomThreshold) / (1 - BloomThreshold));
    
}

technique BloomExtract
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ThePixelShader();
    }
}