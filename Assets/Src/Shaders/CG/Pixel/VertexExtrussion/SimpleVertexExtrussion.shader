Shader "Custom/Pixel/VertexExtrussion/SimpleVertexExtrussion"
{
	// This pixel shader creates the extrussion effect for all vertices

	Properties
	{
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 0.5)) = 0.05
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _OutlineWidth;
			float4 _OutlineColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;		
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 viewDir : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				// Set v.normal to v.vertex if you have hard normals
				float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));

				float2 offset = TransformViewToProjection(norm.xy);

				o.pos.xy += offset * _OutlineWidth * o.pos.z;
				
				// Normal direction
				o.normalDir = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz); 

				// View direction
				o.viewDir = normalize(WorldSpaceViewDir(v.vertex)); 

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half4 c = _OutlineColor;
				return c;
			}
			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}
