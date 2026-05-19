Shader "Custom/HLSL/BlendedColors/AnimHighlightColor"
{
    Properties
    {
		[Header(GENERAL)]

		_BgColor("Background Color", Color) = (1,1,1,1)

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
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalRenderPipeline"
        }

		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			fixed4 _BgColor;
			fixed4 _HighlightColor;

			fixed _HighlightWidth;
			fixed _Vertical;
			fixed _TimeBetweenStripes;
			fixed _Speed;			

			struct appdata
			{
				float4 vertexPos : POSITION;
				fixed2 texCoord : TEXCOORD0;	// This could be float4, or half4, or fixed4... but fixed2 is the most optimus
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
				o.uv = v.texCoord;

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 finalColorRGBA = _BgColor;

				fixed moveDir = _Vertical ? frac(i.uv).y : frac(i.uv).x;
				
				// This goes slowly back to 0 every time _Time is multiple for _TimeBetweenStripes and keeps growing
				fixed limit = fmod(_Time[0] * _Speed, sqrt(_TimeBetweenStripes));

				// Here we paint a striped area relative to limit
				if (moveDir < limit + _HighlightWidth && moveDir > limit - _HighlightWidth)					
				{
					finalColorRGBA = _HighlightColor;
				}		
					
				return finalColorRGBA;
			}
			ENDHLSL
        }
    }
}
