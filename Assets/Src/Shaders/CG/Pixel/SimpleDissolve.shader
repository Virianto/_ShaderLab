Shader "Custom/Pixel/SimpleDissolve"
{
	// This shader produces the archfamous effect of dissolving an object using a texture as shaping base

	Properties
	{
		[Header(Main drawing options)]

		_MainColor("Color", Color) = (1,1,1,1)
		_MainTexture("Texture", 2D) = "white" {}

		[Header(Dissolve drawing options)]

		_DissolveAmount("Dissolve Amount", Range(0, 1)) = 0		
		_DissolveLineColor("Dissolve Line Color", Color) = (1,1,1,1)
		_DissolveLineWidth("Dissolve Line Width", Range(0, 1)) = 0
		_DissolveTex("Dissolve texture", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			half4 _MainColor;
			sampler2D _MainTexture;

			fixed _DissolveAmount;
			fixed _DissolveLineWidth;
			half4 _DissolveLineColor;
			sampler2D _DissolveTex;

			struct appdata
			{
				half4 vertex : POSITION;
				fixed2 uv : TEXCOORD0;
			};

			struct v2f
			{
				half4 vertex : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			
			v2f vert (appdata v)
			{
				v2f o;
				//o.vertex = v.vertex;							// This creates a funny effect on the screen
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 dissolveValue;
				fixed4 c;

				dissolveValue = tex2D(_DissolveTex, i.uv);
				
				c = (_DissolveAmount + _DissolveLineWidth > dissolveValue.r) ? _DissolveLineColor : tex2D(_MainTexture, i.uv) * _MainColor;

				clip((_DissolveAmount < dissolveValue.r) ? 1 : -1);
				return c;
			}
			ENDCG
		}
	}
}