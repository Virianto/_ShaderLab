Shader "Venat/Pixel/AnimatedBlendedColors"
{	
	Properties
	{
		_ColorA("Color A", Color) = (0,0,0,1)
		_ColorB("Color B", Color) = (1,1,1,1)

		_Speed("Speed", Range(-5, 5)) = 0

		[Toggle]
		_Horizontal("Horizontal gradient", Float) = 1
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _ColorA;
			fixed4 _ColorB;
			fixed _Speed;
			fixed _Horizontal;

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

			v2f vert (appdata v)
			{
				v2f o;

				o.vertexPos = UnityObjectToClipPos(v.vertexPos);	
				o.uv = v.texCoord;

				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed direction = _Horizontal ? i.uv.x : i.uv.y;

				fixed stripe = frac(((direction + (_Time.y * _Speed)) * 0.5));
				fixed smoothedStripe = saturate((1 - (smoothstep(0.5, 1, stripe) + smoothstep(0.5, 1, (1 - stripe)))));
				
				fixed4 finalColorRGBA = lerp(_ColorA.rgba, _ColorB.rgba, smoothedStripe);
				
				return finalColorRGBA;
			}
			ENDCG
		}
	}
}