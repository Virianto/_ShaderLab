Shader "Custom/Mixed/FlatFogAura"
{
	// This shader produces this effect: https://realtimevfx.com/t/a-unity-stylized-vfx/2950

	Properties
	{
		[Header(Main drawing options)]

		_MainColor("Color", Color) = (1,1,1,1)
		_Speed("Speed", Range(0, 3)) = 1

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
			Cull off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _MainColor;
			half _Speed;

			fixed _DissolveAmount;
			fixed _DissolveLineWidth;
			half4 _DissolveLineColor;
			sampler2D_half _DissolveTex;

			struct appdata
			{
				half4 vertex : POSITION;
				half3 normal : NORMAL;
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
				o.vertex = UnityObjectToClipPos(v.vertex);

				// Calculate the world normals instead of vertices normals (by multiplying the normal and the matrix)
				//float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));

				//float2 offset = TransformViewToProjection(norm.xy);

				//o.vertex.xy += offset * o.vertex.z;

				o.uv = v.uv * _Time.x * _Speed;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 dissolveValue;
				fixed4 c;

				dissolveValue = tex2D(_DissolveTex, i.uv);
				
				c = _MainColor * dissolveValue;
				//c = (_DissolveAmount + _DissolveLineWidth > dissolveValue.r) ? _DissolveLineColor : _MainColor;

				clip((_DissolveAmount < dissolveValue.r) ? 1 : -1);
				return c;
			}
			ENDCG
		}
	}
}
