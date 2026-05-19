Shader "Custom/Mixed/Outline/AdvancedOutline"
{
	// This mixed shader pretends to be and advanced version of all other outlining shaders combining several
	// features and adding some new

	Properties
	{
		[Header(Cel Shading properties)]

		_ObjectColor("Object Color", Color) = (1,1,1,1)
		_MainTexture("Main Texture", 2D) = "white"{}
		_RampTexture("Ramp Texture", 2D) = "white"{}

		[Header(Outline properties)]

		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(-3, 3)) = 0.05
		_AlphaRange("Alpha range", Range(0, 1)) = 0.5		// !
		_OutlineTexture("Outline Texture", 2D) = "white"{}

		[Header(Noise properties)]

		_Speed("Speed", Range(-3, 3)) = 0.05
		_NoiseTexture("Noise Texture", 2D) = "white"{}
	}

	SubShader
	{
		// FIRST Paint the object itself in a simple way (could use any other surface filter like Cel Shading):

		CGPROGRAM

		#pragma surface surf CelShading

		float4 _ObjectColor;
		sampler2D _MainTexture;
		sampler2D _RampTexture;

		// The name of this function must be "Lighting" + "what we have written after 'surf' in #pragma if it's different from defaults
		// such as 'Lambert'"
		// The s is a SurfaceOutput structure, the lightDir is the direction light is coming and atten is an attenuation value
		half4 LightingCelShading(SurfaceOutput s, fixed3 lightDir, fixed3 atten)
		{
			float diff = dot(s.Normal, lightDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			float3 ramp = tex2D(_RampTexture, rh).rgb;

			float4 c;

			// _LightColor0 comes with the 'includes' and provides information about all the lights affecting the object with this shader
			c.rgb = s.Albedo * _LightColor0.rgb * ramp;
			c.a = s.Alpha;

			return c;
		}

		struct Input
		{
			float3 worldPos;
			fixed2 uv_MainTexture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture).rgb * _ObjectColor.rgb;
		}

		ENDCG

		// SECOND create the outline effect:

		Pass
		{
			// Remove those vertices which are not facing the camera frontally (otherwise, outlining would hide the object behind it)
			Cull Off

			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				float _OutlineWidth;
				fixed _AlphaRange;
				fixed _Speed;
				fixed4 _OutlineColor;
				sampler2D _NoiseTexture; 
				sampler2D _OutlineTexture;

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					fixed4 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 color : COLOR;
					fixed4 texCoord : TEXCOORD0;
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

					o.color = tex2Dlod(_OutlineTexture, v.uv) * _OutlineColor;

					return o;
				}

				half4 frag(v2f i) : SV_Target
				{
					clip(i.color.r > (1 - _AlphaRange) ? 1 : -1);
					return i.color;
				}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}