Shader "_ViriantoTem/HLSL/FullScreenFX/FS_VoronoiAndVignette"
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
        [Header(GENERAL)]
        
        [Header(Vignetting)]
        
        [KeywordEnum(Screen, Circle, Vertical, Horizontal)]
        _VignetteMode("Vignette Mode", Float) = 0
        
        _VignetteSize("Vignette Size", Range(2, 64)) = 0.5
        
        [IntRange]
        _VignetteHardness("Vignette Softness", Range(-128, 128)) = 24
        
        [Header(Voronoi)]
        
        [IntRange]
        _Scale ("Scale", Range(-16, 16)) = 4
        
        [IntRange]
        _Speed ("Speed", Range(-2, 2)) = 1
        
        [IntRange]
        _Jitter ("Jitter", Range(-3, 3)) = 1
        
        _AttenuationPower ("Attenuation Power", Range(0.001, 3)) = 0.1

        _CellsColor ("Cells Color", Color) = (0.05, 0.08, 0.12, 1)

        _SceneBlend ("Scene Blend", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
        }
        
        ZWrite Off
        Cull Off

        Pass
        {
            Name "FullScreenVoronoi"

            HLSLPROGRAM

            #pragma vertex Vert
            #pragma fragment pixelShader
            
            // Custom pragma for different vignette modes. Names MUST match "_VIGNETTEMODE" + Enum name
            #pragma shader_feature_local _VIGNETTEMODE_SCREEN _VIGNETTEMODE_CIRCLE _VIGNETTEMODE_VERTICAL _VIGNETTEMODE_HORIZONTAL

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            CBUFFER_START(UnityPerMaterial)
                       
                min16float _VignetteMode;
                min16float _VignetteSize;
                min16float _VignetteHardness;
            
                min16float _Scale;
                min16float _Speed;
                min16float _Jitter;
                min16float _AttenuationPower;

                min16float4 _CellsColor;

                min16float _SceneBlend;
            
            CBUFFER_END

            // Custom function to manage vignette modes
            min10float GetVignette(min10float2 uv)
            {          
                min10float vignette;
                
                #if defined(_VIGNETTEMODE_SCREEN)

                    vignette = pow(length(uv) * _VignetteSize, _VignetteHardness);

                #elif defined(_VIGNETTEMODE_CIRCLE)

                    // This is possible thanks to the HLSL include
                    min10float aspect = _ScreenParams.x / _ScreenParams.y;
                       
                    uv.x *= aspect;
                    vignette = pow(length(uv) * _VignetteSize, _VignetteHardness);

                #elif defined(_VIGNETTEMODE_VERTICAL)

                    vignette = pow(length(uv.x) * _VignetteSize, _VignetteHardness);

                #elif defined(_VIGNETTEMODE_HORIZONTAL)

                    vignette = pow(length(uv.y) * _VignetteSize, _VignetteHardness);

                #endif
                
                return vignette;
            }
            
            inline min16float2 VoronoiRandomVector (float2 UV, float offset)
            {
                min16float2x2 m = min16float2x2(13, 43, 81, 72);
                UV = frac(sin(mul(UV, m)) * 6699);
                return min16float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
            }

            void VoronoiEffect(min16float2 UV, min16float AngleOffset, min16float CellDensity, out min16float Out, out min16float Cells)
            {
               min16float2 g = floor(UV * CellDensity);
               min16float2 f = frac(UV * CellDensity);
               min16float3 res = min16float3(9, 0, 0);

                for(int y=-1; y<=1; y++)
                {
                    for(int x=-1; x<=1; x++)
                    {
                        min16float2 lattice = min16float2(x,y);
                        min16float2 offset = VoronoiRandomVector(lattice + g, AngleOffset);
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

                min10float2 centeredUV = uv - 0.5;

                min10float vignette = GetVignette(centeredUV);
                
                min16float time = _Time.y * _Speed;
                
                min16float2 voronoiResult;
                
                VoronoiEffect(uv * _Scale, time, _Scale, voronoiResult.x, voronoiResult.y);
                
                min16float edgeStrength = lerp(voronoiResult.x, voronoiResult.y, _Jitter);
                min16float attenuation = pow(edgeStrength, _AttenuationPower);
                
                min10float2 mix = voronoiResult * vignette;
                
                mix *= attenuation;
                
                min16float4 result = _CellsColor * screenColor * attenuation;
                
                result.rgb *= (1.0 - vignette);
                
                result = lerp(screenColor, result, _SceneBlend);
                
                return result;
            }

            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
