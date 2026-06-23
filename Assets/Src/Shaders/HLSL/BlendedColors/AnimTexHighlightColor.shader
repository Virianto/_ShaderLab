Shader "_ViriantoTem/HLSL/BlendedColors/AnimTexHighlightColor"
{
    Properties
    {
        [Header(GENERAL)]

        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("Main color", Color) = (1,1,1,1)

		[Header(COMPARISON)]

		_ColorTolerance("Color tolerance", Range(0, 1)) = 0.2

        _ComparisonColor("Comparison color", Color) = (0,0,0,1)

        [HDR]
        _HighlightColor("Highlight Line Color", Color) = (1,1,1,1)

        _HighlightWidth("Highlight Line Width", Range(0, 1)) = 0

        [Header(ANIMATION)]

        [Toggle]
        _Vertical("Move through Y?", Float) = 1

        _Speed("Speed", Range(-10, 10)) = 1

        _TimeBetweenStripes("Time between stripes", Range(-10, 10)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        //Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			sampler2D _MainTex;
			fixed4 _MainColor;
			fixed4 _ComparisonColor;
			fixed4 _HighlightColor;

			fixed _HighlightWidth;
			fixed _Vertical;
			fixed _TimeBetweenStripes;
			fixed _Speed;
			fixed _ColorTolerance;

			struct appdata
			{
				float4 vertexPos : POSITION;
				fixed2 uv : TEXCOORD0;	
			};

			struct v2f
			{
				float4 vertexPos : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;

				o.vertexPos = TransformObjectToHClip(v.vertexPos);
				o.uv = v.uv;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 finalColorRGBA = tex2D(_MainTex, i.uv) * _MainColor;

				fixed moveDir = _Vertical ? frac(i.uv).y : frac(i.uv).x;

				// This goes slowly back to 0 every time _Time is multiple for _TimeBetweenStripes and keeps growing
				fixed limit = fmod(_Time[0] * _Speed, sqrt(_TimeBetweenStripes));
				
				// Here we paint a striped area relative to limit
				if (moveDir < limit + _HighlightWidth && moveDir > limit - _HighlightWidth)
				{
					// Get a complete comparison between original color in texture and replacing one
					fixed3 colorDiff = abs(finalColorRGBA.rgb - _ComparisonColor.rgb);
					bool colorsSimilar = all(colorDiff <= _ColorTolerance);
					
					if(colorsSimilar)
					{
						finalColorRGBA = _HighlightColor;
					}
				}
								
				return finalColorRGBA;
			}
			ENDHLSL
        }
    }
}