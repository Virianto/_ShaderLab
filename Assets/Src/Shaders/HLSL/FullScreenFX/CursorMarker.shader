Shader "_ViriantoTem/HLSL/FullScreenFX/CursorMarker"
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
        _Color("Color", Color) = (1, 1, 1, 1)
        _Radius("Radius", Range(4, 128)) = 8
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
            
            min16float4 _Color;
            min16float _Radius;
            min16float4 _CursorPos;
           
            min16float4 pixelShader(Varyings IN) : SV_Target
            {
                min16float2 currentPosition = _CursorPos.xy;
                
                min16float2 uv = floor(IN.texcoord * _PixelSize) / _PixelSize;
                
                min16float4 color = SAMPLE_TEXTURE2D(_BlitTexture, sampler_PointClamp, uv);
                
                return color;
            }
            
            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}