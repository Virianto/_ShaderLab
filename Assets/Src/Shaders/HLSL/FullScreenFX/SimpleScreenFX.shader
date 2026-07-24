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
                uint vertexID : SV_VertexID;
            };

            struct v2p
            {
                half4 positionCS : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BlitTexture);
            SAMPLER(sampler_BlitTexture);

            v2p vertexShader(vertexInfo input)
            {
                v2p o;

                o.uv = half2(
                    (input.vertexID << 1) & 2,
                    input.vertexID & 2
                );

                o.positionCS = half4(o.uv * 2.0 - 1.0, 0.0, 1.0);

                return o;
            }
           
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
