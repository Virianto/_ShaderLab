Shader "Custom/Mixed/Outline/CelShadingOutline"
{
	// This shader is a mix of SimpleOutline and 

	Properties
	{
		_ObjectColor("Object Color", Color) = (1,1,1,1)
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 0.5)) = 0.05
		_RampTexture("Ramp Texture", 2D) = "white"{}
	}

	SubShader
	{
		// FIRST Paint the object itself:

		CGPROGRAM

		#pragma surface surf CelShading

		float4 _ObjectColor;
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
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _ObjectColor.rgb;
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
				fixed4 _OutlineColor;

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
					float2 offset = TransformViewToProjection(norm.xy);
					o.pos.xy += offset * o.pos.z * _OutlineWidth;
					o.color = _OutlineColor;

					return o;
				}
				
				half4 frag(v2f i) : SV_Target
				{
					return i.color;
				}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}
