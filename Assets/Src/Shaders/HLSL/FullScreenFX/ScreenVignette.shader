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
        _VignetteIntensity("Vignette Intensity", Range(-1, 1)) = 8
        
        [IntRange]
        _VignetteRadius("Vignette Radius", Range(-127, 127)) = 8
        
        // Definir un centro editable desde código para combinar con el cursor
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
            Name "FullScreenPass"
            
            HLSLPROGRAM

            #pragma vertex Vert
			#pragma fragment pixelShader

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
            
            // UNIFORMS: External parameters
            
            min10float2 _VignetteCenter;
            min16float _VignetteIntensity;
            min16float _VignetteRadius;
           
            min16float4 pixelShader(Varyings IN) : SV_Target
            {
                _VignetteCenter = (0.5f, 0.5f);
                
                // This is possible thanks to the HLSL include
                min10float aspect = _ScreenParams.x / _ScreenParams.y;
                min10float2 uv = IN.texcoord;
                
                //
                min16float4 result = min16float4(0, 0, 0, 0);
                
                float2 centeredUV = IN.texcoord - 0.5;

                float vignette =
                pow(
                    length(_VignetteCenter) * _VignetteIntensity,
                    _VignetteRadius
                    );

                vignette = saturate(vignette);

                result.rgb *= (1.0 - vignette);
                return result;
                
                
               // min16float4 color = SAMPLE_TEXTURE2D(_BlitTexture, sampler_PointClamp, uv);
                
                //return color;
            }
            
            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
