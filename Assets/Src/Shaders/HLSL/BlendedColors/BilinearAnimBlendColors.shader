Shader "Custom/HLSL/BilinearAnimBlendColors"
{
	// C ---- D
	// |      |
	// |      |
	// A ---- B

	Properties
	{				
		_ColorA("Color A", Color) = (1, 0, 0, 1)
		_ColorB("Color B", Color) = (0, 1, 0, 1)
		_ColorC("Color C", Color) = (0, 0, 1, 1)
		_ColorD("Color D", Color) = (1, 0, 1, 1)

		_Speed("Speed", Range(-5, 5)) = 0

		[Toggle]
		_Vertical("Vertical gradient", Float) = 1
	}

	SubShader
	{
		Pass
		{
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			fixed4 _ColorA;
			fixed4 _ColorB;
			fixed4 _ColorC;
			fixed4 _ColorD;
			fixed _Speed;
			fixed _Vertical;

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
				fixed4 finalColorRGBA;

				fixed moveDir = _Vertical ? i.uv.x : i.uv.y;
				fixed gradDir = _Vertical ? i.uv.y : i.uv.x;

				fixed4 colorY1 = (1.0 - gradDir) * _ColorA.rgba + gradDir * _ColorB.rgba;
				fixed4 colorY2 = (1.0 - gradDir) * _ColorC.rgba + gradDir * _ColorD.rgba;

				fixed stripe = frac(((moveDir + (_Time.y * _Speed)) * 0.5));
				fixed smoothedStripe = saturate((1 - (smoothstep(0.5, 1, stripe) + smoothstep(0.5, 1, (1 - stripe)))));

				finalColorRGBA = lerp(colorY1.rgba, colorY2.rgba, smoothedStripe);					
					
				return finalColorRGBA;
			}
			ENDHLSL
		}
	}
}