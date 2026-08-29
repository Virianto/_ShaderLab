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
        _Color("Color", Color) = (1, 1, 1, 0)
        _Radius("Radius", Range(0, 32)) = 1
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
                // This is possible thanks to the HLSL include
                min10float aspect = _ScreenParams.x / _ScreenParams.y;
                min10float2 uv = IN.texcoord;
                
                // Scalating
                uv.x *= aspect;
                _CursorPos.x *= aspect;
                
                //min16float dist = distance(IN.texcoord, _CursorPos.xy);
                min16float dist = distance(uv, _CursorPos.xy);

                min16float circle = step(dist, _Radius);

                min16float4 background = float4(0,0,0,0);
                
                min16float4 result = SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearClamp, IN.texcoord);

                //result = step(result, _Color * circle) ? _Color : result;
                
                result = lerp(background, _Color, circle);
                
                clip( result.a <= 0 ? -1 : 1 );
                
                return result;
            }
            
            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}