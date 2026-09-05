Shader "_ViriantoTem/HLSL/FullScreenFX/VoronoiNoiseBG"
{
    // This shader is used to render a fullscreen effect.
    
    // To keep it simple, we'll be including Runtime/Utilities/Blit.hlsl which means:
    // 1. Pragma Vertex is declared but not implemented here
    // 2. fragmentShader input MUST be of type "Varyings" as it's declared in Blit.hlsl
    // 3. There's no need to declare TEXTURE2D(_BlitTexture) nor its sampler
    
    // Screen UVs are mapped like this:
    /*  (0,0) -------- (1,0)
        |                  |
        |                  |
        |                  |
        (0,1) -------- (1,1) */
    
    Properties
    {
        [IntRange]
        _Scale ("Scale", Range(-16, 16)) = 4
        
        [IntRange]
        _Speed ("Speed", Range(-2, 2)) = 1
        
        [IntRange]
        _Jitter ("Jitter", Range(-3, 3)) = 1
        
        
        _LineWidth ("Line Width", Range(0.001, 0.2)) = 0.03

        _CellColorA ("Cell Color A", Color) = (0.05, 0.08, 0.12, 1)
        _CellColorB ("Cell Color B", Color) = (0.2, 0.6, 1.0, 1)
        _EdgeColor ("Edge Color", Color) = (1.0, 0.9, 0.25, 1)

        _SceneBlend ("Scene Blend", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            Name "Moving Voronoi Fullscreen"

            HLSLPROGRAM

            #pragma vertex Vert
            #pragma fragment pixelShader

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _Scale;
                float _Speed;
                float _Jitter;
                float _LineWidth;

                float4 _CellColorA;
                float4 _CellColorB;
                float4 _EdgeColor;

                float _SceneBlend;
            CBUFFER_END
                        
            float2 Hash22(float2 p)
            {
                float2 q;
                q.x = dot(p, float2(127.1, 311.7));
                q.y = dot(p, float2(269.5, 183.3));

                return frac(sin(q) * 43758.5453);
            }

            float3 Voronoi(float2 uv, float time)
            {
                float2 cell = floor(uv);
                float2 local = frac(uv);

                float nearestDist = 999.0;
                float secondDist = 999.0;
                float cellRandom = 0.0;

                for (int y = -1; y <= 1; y++)
                {
                    for (int x = -1; x <= 1; x++)
                    {
                        float2 offset = float2(x, y);
                        float2 cellId = cell + offset;

                        float2 rnd = Hash22(cellId);

                        float2 animatedPoint =
                            0.5 + 0.5 * sin(time + rnd * 6.2831853 + float2(0.0, 2.0));

                        float2 p = lerp(rnd, animatedPoint, _Jitter);

                        float2 diff = offset + p - local;
                        float dist = dot(diff, diff);

                        if (dist < nearestDist)
                        {
                            secondDist = nearestDist;
                            nearestDist = dist;
                            cellRandom = Hash22(cellId).x;
                        }
                        else if (dist < secondDist)
                        {
                            secondDist = dist;
                        }
                    }
                }

                float d1 = sqrt(nearestDist);
                float d2 = sqrt(secondDist);

                float edgeDistance = d2 - d1;

                return float3(d1, edgeDistance, cellRandom);
            }

            float4 pixelShader(Varyings IN) : SV_Target
            {
                float2 uv = IN.texcoord;

                float4 sceneColor = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, uv);

                float time = _Time.y * _Speed;                

                float3 v = Voronoi(uv * _Scale, time);

                float edge = 1.0 - smoothstep(_LineWidth, _LineWidth * 2.0, v.y);

                float3 cellColor = lerp(_CellColorA.rgb, _CellColorB.rgb, v.z);

                float3 voronoiColor = lerp(cellColor, _EdgeColor.rgb, edge);

                float3 finalColor = lerp(voronoiColor, sceneColor.rgb * voronoiColor, _SceneBlend);

                return float4(finalColor, 1.0);                
            }

            ENDHLSL
        }
    }
}