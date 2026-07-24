Shader "_ViriantoTem/HLSL/FullScreenFX/SimpleScreenFX"
{
    // This shader is used to render a fullscreen quad with a single color and texture.
    // Screen UVs are mapped like this:
    /*  (0,0) -------- (1,0)
        |                  |
        |                  |
        |                  |
        (0,1) -------- (1,1) */
    
    Properties
    {
        
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
        }

        Pass
        {
            Name "FullScreenPass"
            
            HLSLPROGRAM

            #pragma vertex vertexShader
			#pragma fragment pixelShader

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct vertexInfo
            {
                half4 positionOS : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct v2p
            {
                half4 positionHCS : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BlitTexture);
            SAMPLER(sampler_BlitTexture);
           
            half4 pixelShader(v2p IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BlitTexture, sampler_BlitTexture, IN.uv);
                
                color.rgb = 1 - color.rgb;
                
                return color;
            }
            
            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
