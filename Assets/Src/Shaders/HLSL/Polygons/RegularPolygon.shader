Shader "_ViriantoTem/HLSL/Polygons/RegularPolygon"
{    
    Properties
    {
        [IntRange]
        _Sides ("Sides", Range(3, 12)) = 6

        _PolygonColor ("Polygon Color", Color) = (0.05, 0.08, 0.12, 1)
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
            Name "SimplePolygon"

            HLSLPROGRAM

            #pragma vertex Vert
            #pragma fragment pixelShader
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            // UNIFORMS: External parameters
            
            CBUFFER_START(UnityPerMaterial)
            
                min16float _Sides;

                min16float4 _PolygonColor;
            
            CBUFFER_END
     
            void DrawPolygon(min16float2 UV, min16float Sides, min16float Width, min16float Height, out min16float Out)
            {
                min16float pi = 3.14159265359;
                min16float aWidth = Width * cos(pi / Sides);
                min16float aHeight = Height * cos(pi / Sides);
                min16float2 uv = (UV * 2 - 1) / min16float2(aWidth, aHeight);
                uv.y *= -1;
                min16float pCoord = atan2(uv.x, uv.y);
                min16float r = 2 * pi / Sides;
                min16float distance = cos(floor(0.5 + pCoord / r) * r - pCoord) * length(uv);
                
                Out = saturate((1 - distance) / fwidth(distance));
            }
            
            min16float4 pixelShader(Varyings IN) : SV_Target
            {
                min10float r;
                DrawPolygon(IN.texcoord, _Sides, 1, 1, r);
                return _PolygonColor * r;
            }

            ENDHLSL
        }
    }
    // DISCLAIMER: I don't trust anybody's using Shader Precision Model - UNIFIED.
	// That's why I'm using 'min16float' instead of 'half' everywhere. If you know what
	// you're doing, you can change it to half in order to improve readability ^_^
}
