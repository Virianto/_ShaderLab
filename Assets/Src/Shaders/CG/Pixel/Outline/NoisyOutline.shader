Shader "Custom/Mixed/Outline/NoisyOutline" 
{
	// This mixed shader combines functionality from "SimpleOutline" adding the ability of painting a texture on the surface and
	// noise to the outlined volume

	Properties
	{
		[Header(Main properties)]

		_ObjectColor("Object Color", Color) = (1,1,1,1)
		_MainTexture("Main Texture", 2D) = "white"{}

		[Header(Outline properties)]

		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 3)) = 0.05

			_Speed("Speed", Range(0, 3)) = 0.05
		_NoiseTexture("Noise Texture", 2D) = "white"{}
	}

	SubShader
	{
		// FIRST Paint the object itself in a simple way (could use any other surface filter like Cel Shading):

		CGPROGRAM

		#pragma surface surf Lambert

		sampler2D _MainTexture;
		fixed4 _ObjectColor;

		struct Input
		{
			float2 uv_MainTexture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture).rgb * _ObjectColor;
		}

		ENDCG

		// SECOND create the outline effect:

		Pass
		{
			// Remove those vertices which are not facing the camera frontally (otherwise, outlining would hide the object behind it)
			Cull Front

			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				float _OutlineWidth;
				fixed _Speed;
				fixed4 _OutlineColor;
				sampler2D _NoiseTexture;

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 color : COLOR;
				};

				v2f vert(appdata v)
				{
					v2f o;

					o.pos = UnityObjectToClipPos(v.vertex);

					// Calculate the world normals instead of vertices normals (by multiplying the normal and the matrix)
					float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));

					half d = tex2Dlod(_NoiseTexture, float4(v.vertex.x, v.vertex.y + (_Time.y * _Speed), 0, 0));

					float2 offset = TransformViewToProjection(norm.xy);

					o.pos.xy += offset * o.pos.z * _OutlineWidth * d;

					o.color = _OutlineColor;

					return o;
				}

				half4 frag(v2f i) : SV_Target
				{
					clip(i.color.a > 0.1 ? 1 : -1);
					return i.color;
				}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}
