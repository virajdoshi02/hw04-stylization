SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb*2.-float3(1.,1.,1.);
}

#ifndef SOBELOUTLINES_INCLUDED
#define SOBELOUTLINES_INCLUDED

static float2 sobelSamplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void DepthSobel_float(float2 UV, float Thickness, out float Out) {
    float2 sobel = 0;
    [unroll] for (int i = 0; i < 9; i++) {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    Out = length(sobel);
}

#endif


#ifndef GETCROSSSAMPLES
#define GETCROSSSAMPLES

void GetCrossSample_float(float2 UV, float2 TexelSize, float OffsetMultiplier,
out float2 uv_og, out float2 uv_tr, out float2 uv_bl, out float2 uv_tl, out float2 uv_br){
uv_og = UV;
uv_tr = UV.xy + float2(TexelSize.x, TexelSize.y)*OffsetMultiplier;
uv_bl = UV.xy - float2(TexelSize.x, TexelSize.y)*OffsetMultiplier;
uv_tl = UV.xy + float2(-TexelSize.x, TexelSize.y)*OffsetMultiplier;
uv_br = UV.xy + float2(TexelSize.x, -TexelSize.y)*OffsetMultiplier;
}

#endif