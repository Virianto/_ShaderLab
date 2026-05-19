Shader "Custom/Pixel/Rim/AlphaNoisyRim"
{
	// *Texture sampling optimization for mobile: https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html

	Properties
	{
		[Header(Cel Shading properties)]

		_ObjectColor("Object Color", Color) = (1,1,1,1)
		_MainTexture("Main Texture", 2D) = "white"{}
		_RampTexture("Ramp Texture", 2D) = "white"{}

		[Header(Outline properties)]

		_OutlineColor_1("Outline Color", Color) = (1,1,1,1)
		_OutlineColor_2("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 3)) = 0.05

		_Edge("Rim Edge", Range(0.0, 1)) = 0.1
		_RimPower("Rim Power", Range(0.01, 10.0)) = 1

		[Header(Noise properties)]

		_NoiseSpeed("Noise Speed", Range(-2, 2)) = 1
		_DissolveAmount("Dissolve Amount", Range(0, 1)) = 0
		_NoiseTexture("Noise Texture", 2D) = "white"{}

		[Header(Blending options)]

		[Enum(UnityEngine.Rendering.BlendMode)]
		_BlendingSource("Blending Source", Float) = 1

		[Enum(UnityEngine.Rendering.BlendMode)]
		_BlendingDestiny("Blending Destiny", Float) = 1
	}

	SubShader
	{
		// FIRST Paint the object itself in a simple way (could use any other surface filter like Cel Shading):

		CGPROGRAM

			#pragma surface surf CelShading

			float4 _ObjectColor;
			sampler2D_half _MainTexture;
			sampler2D_half _RampTexture;

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
			Cull Back
			ZWrite Off
			ColorMask RGB
			// https://docs.unity3d.com/Manual/SL-Blend.html and https://docs.unity3d.com/ScriptReference/Rendering.BlendMode.html
			Blend [_BlendingSource] [_BlendingDestiny]

			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				fixed _OutlineWidth;
				fixed _NoiseSpeed;
				fixed _DissolveAmount;

				fixed _Edge;
				fixed _RimPower;

				fixed4 _OutlineColor_1;	
				fixed4 _OutlineColor_2;

				sampler2D_half _NoiseTexture; 

				struct appdata
				{
					half4 vertex : POSITION;
					half3 normal : NORMAL;
					half2 uv : TEXCOORD0;
				};

				struct v2f
				{
					half4 pos : SV_POSITION;
					half2 uv : TEXCOORD0;
					half3 viewDir : TEXCOORD1;
					half3 normalDir : TEXCOORD2;
				};

				v2f vert(appdata v)
				{
					v2f o;

					o.pos = UnityObjectToClipPos(v.vertex);

					// Calculate the world normals instead of vertices normals (by multiplying the normal and the matrix)
					float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
					
					float2 offset = TransformViewToProjection(norm.xy);

					o.pos.xy += offset * o.pos.z * _OutlineWidth;
					o.uv = v.uv;
					
					o.normalDir = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz); // normal direction
					o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

					return o;
				}
				
				half4 frag(v2f i) : SV_Target
				{
					// Working rim wich can be modulated through _RimPower
					half4 rim = pow(1 - dot(normalize(i.viewDir), i.normalDir), _RimPower);

					float2 uv = float2(i.uv.x - _Time.x, i.uv.y - _Time.x); 
					float4 text = tex2D(_NoiseTexture, uv);

					//float4 rim = pow(saturate(dot(i.viewDir, i.normalDir)), _RimPower); // calculate inverted rim based on view and normal

					// subtract noise texture
					rim.a -= text.r; 
					float4 texturedRim = saturate(rim.a * _DissolveAmount); // make a harder edge
					float4 extraRim = (saturate((_Edge + rim.a) * _DissolveAmount) - texturedRim);// extra edge, subtracting the textured rim
					half4 result = (_OutlineColor_2 * texturedRim) + (_OutlineColor_1 * extraRim);// combine both with colors
					//half4 result = _OutlineColor_1 * texturedRim;
					clip(result.a >= _DissolveAmount ? 1 : -1);

					
					return result;
					//return _OutlineColor_1 * rim;
				}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}
