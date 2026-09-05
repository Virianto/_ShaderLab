Shader "_ViriantoTem/HLSL/FullScreenFX/ScreenVignette"
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
        [KeywordEnum(Screen, Circle, Vertical, Horizontal)]
        _VignetteMode("Vignette Mode", Float) = 0
        
        _VignetteSize("Vignette Size", Range(2, 64)) = 0.5
        
        [IntRange]
        _VignetteSoftness("Vignette Softness", Range(-128, 128)) = 24
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
            Name "FullScreenVignette"
            
            HLSLPROGRAM

            #pragma vertex Vert
			#pragma fragment pixelShader
            
            // Custom pragma for different vignette modes. Names MUST match "_VIGNETTEMODE" + Enum name
            #pragma shader_feature_local _VIGNETTEMODE_SCREEN _VIGNETTEMODE_CIRCLE _VIGNETTEMODE_VERTICAL _VIGNETTEMODE_HORIZONTAL

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
            
            // UNIFORMS: External parameters
            
            min16float _VignetteMode;
            min16float _VignetteSize;
            min16float _VignetteSoftness;
           
            // Custom function to manage vignette modes
            min10float GetVignette(min10float2 uv)
            {          
                min10float vignette;
                
                #if defined(_VIGNETTEMODE_SCREEN)

                    vignette = pow(length(uv) * _VignetteSize, _VignetteSoftness);

                #elif defined(_VIGNETTEMODE_CIRCLE)

                    // This is possible thanks to the HLSL include
                    min10float aspect = _ScreenParams.x / _ScreenParams.y;
                       
                    uv.x *= aspect;
                    vignette = pow(length(uv) * _VignetteSize, _VignetteSoftness);

                #elif defined(_VIGNETTEMODE_VERTICAL)

                    vignette = pow(length(uv.x) * _VignetteSize, _VignetteSoftness);

                #elif defined(_VIGNETTEMODE_HORIZONTAL)

                    vignette = pow(length(uv.y) * _VignetteSize, _VignetteSoftness);

                #endif
                
                return vignette;
            }
            
            min16float4 pixelShader(Varyings IN) : SV_Target
            {                
                min10float2 uv = IN.texcoord;                
                
                min16float4 result = SAMPLE_TEXTURE2D(_BlitTexture, sampler_PointClamp, uv);
                
                min10float2 centeredUV = uv - 0.5;

                min10float vignette = GetVignette(centeredUV);

                result.rgb *= (1.0 - vignette);
                return result;
            }
            
            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
