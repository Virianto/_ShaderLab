Shader "_ViriantoTem/HLSL/FullScreenFX/ScreenVoronoi"
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
                            
                min16float _Scale;
                min16float _Speed;
                min16float _Jitter;
                min16float _LineWidth;

                min16float4 _CellColorA;
                min16float4 _CellColorB;
                min16float4 _EdgeColor;

                min16float _SceneBlend;
            
            CBUFFER_END

            inline min16float2 unity_voronoi_noise_randomVector (float2 UV, float offset)
            {
                min16float2x2 m = min16float2x2(15.27, 47.63, 99.41, 89.98);
                UV = frac(sin(mul(UV, m)) * 46839.32);
                return min16float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
            }

            void Unity_Voronoi_float(min16float2 UV, min16float AngleOffset, min16float CellDensity, out min16float Out, out min16float Cells)
            {
               min16float2 g = floor(UV * CellDensity);
               min16float2 f = frac(UV * CellDensity);
               min16float3 res = min16float3(8.0, 0.0, 0.0);

                for(int y=-1; y<=1; y++)
                {
                    for(int x=-1; x<=1; x++)
                    {
                        min16float2 lattice = min16float2(x,y);
                        min16float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset);
                        min16float d = distance(lattice + offset, f);
                        if(d < res.x)
                        {
                            res = min16float3(d, offset.x, offset.y);
                            Out = res.x;
                            Cells = res.y;
                        }
                    }
                }
            }
                      
            min16float4 pixelShader(Varyings IN) : SV_Target
            {
                min16float2 uv = IN.texcoord;

                min16float4 screenColor = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, uv);

                min16float time = _Time.y * _Speed;
                
                min16float2 vResult;
                
                Unity_Voronoi_float(uv * _Scale, time, _Scale, vResult.x, vResult.y);
                
                min16float v = lerp(vResult.x, vResult.y, _Jitter);
                min16float w = pow(v, 2.0);
                
                min16float4 result = screenColor * w;
                
                result = lerp(screenColor, result, _SceneBlend);
                
                return result;
            }

            ENDHLSL
        }
    }
}
