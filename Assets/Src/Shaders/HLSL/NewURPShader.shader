Shader "DeltaNet/TrailMesh"
{
	Properties
	{
		_Color("Main Color", Color) = (1, 0.5, 0.5, 0.5)
	}

		SubShader
	{
		Blend SrcAlpha One
		Cull off	// This makes vertices not facing camera to be painted too		

		Pass
		{
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _Color;

			struct appdata
			{
				float4 vertexPos : POSITION;
				fixed2 texCoord : TEXCOORD0;	// This could be float4, or half4, or fixed4... but fixed2 is the most optimus
			};

			struct v2f
			{
				float4 vertexPos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertexPos = UnityObjectToClipPos(v.vertexPos);
				o.uv = fixed4(v.texCoord.xy, 0, 0);					// We need fixed4 here because we're working with 4 values of type "fixed"
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed limit = fmod(_Time[1] * 0.5, 1.1);		// This goes slowly back to 0 every time _Time is multiple for 1.1 and keeps growing

				if (frac(i.uv).x < limit + 0.1 &&
					frac(i.uv).x > limit - 0.1)					// Here we paint a vertical area relative to limit
				{
					_Color.r = 1;
					_Color.g = 1;
					_Color.b = 1;
				}

				_Color.a = (abs(_SinTime[3]) / 4) + 0.1;		// Slowly modifies object alpha to give it a soft glowing effect
				return _Color;
			}
			ENDHLSL
		}
	}
}