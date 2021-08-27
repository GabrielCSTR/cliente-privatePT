// ��˹ģ������
// �����ЧҪӦ�����Σ�һ��Ϊ����ģ������һ��Ϊ����ģ�������ϵ�����ģ�����Լ����㷨�ϵ�ʱ�临�Ӷ�
// ����Ӧ��Bloom��Ч���м䲽��

sampler TextureSampler : register(s0);

#define SAMPLE_COUNT 15

// ƫ������
float2 SampleOffsets[SAMPLE_COUNT];
// Ȩ������
float SampleWeights[SAMPLE_COUNT];

float4 ThePixelShader(float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 c = 0;
    
    // ��ƫ�Ƽ�Ȩ�����������Χ��ɫֵ��������
    // ���ԭ���������Ϊ��������ɫ���ض�Ȩ�ط�ɢ����Χƫ������
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