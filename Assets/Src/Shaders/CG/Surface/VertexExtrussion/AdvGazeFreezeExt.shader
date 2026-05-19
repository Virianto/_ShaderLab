Shader "Custom/AdvGazeFreezeExt" 
{
	// Same functionality as in GazeFreezeExt adding some color blending and cel shading lighting

	Properties
	{
		[Header(General properties)]

		_MainColor("Main Color", Color) = (1,1,1,1)
		
		[NoScaleOffset]
		_MainTex("Main Texture", 2D) = "white" {}

		[NoScaleOffset]
		_RampTex("Ramp Texture", 2D) = "white" {}

		[Header(Gaze properties)]

		_GazeColor("Gaze Color", Color) = (1,1,1,1)

		_X("X", Range(-1, 1)) = 0
		_Y("Y", Range(-1, 1)) = 0
		_Z("Z", Range(-1, 1)) = 0

		_Tolerance("Tolerance", Range(-1,1)) = 0

		[Header(Freezing properties)]

		_IceColor("Ice Color", Color) = (1,1,1,1)
		_IceLength("Ice Length", Range(-3, 3)) = 0
		_IceWidth("Ice Width", Range(0, 1)) = 0.1

		[NoScaleOffset]
		_NoiseTexture("Noise Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

		CGPROGRAM		

			#pragma vertex vert	
			#pragma surface surf CelShading

			#include "UnityCG.cginc"

			fixed _X;
			fixed _Y;
			fixed _Z;

			half _Tolerance;
			half _IceLength;
			half _IceWidth;

			fixed3 gazeDir;
			
			fixed4 _MainColor;
			fixed4 _GazeColor;

			sampler2D _MainTex;
			sampler2D _RampTex;
			sampler2D _NoiseTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct Input
			{
				float3 worldPos;
				float2 texCoord;
			};

			// VERTEX MANAGEMENT -
			
			void vert(inout appdata v, out Input o)
			{
				gazeDir = fixed3(_X, _Y, _Z);

				// Get a value which tells us if myVector and v.normal are facing each other (-><-) = -1 or not (<-<-) = 1	
				fixed d = dot(gazeDir, v.normal);
				half noiseExtrussion = tex2Dlod(_NoiseTexture, v.uv) * _IceLength;
				
				//v.vertex.xyz += d > _Tolerance ? (gazeDir * noiseExtrussion) : 0;
				//v.vertex.xyz += (d < (_Tolerance - _IceWidth) || d >= (_Tolerance + _IceWidth)) ? 0 : (gazeDir * noiseExtrussion);
				v.vertex.xyz += abs(d) < _IceWidth ? (gazeDir * noiseExtrussion) : 0;
				
				o.worldPos = v.vertex;
				o.texCoord = v.uv;
			}

			// VERTEX MANAGEMENT -

			// SURFACE MANAGEMENT -			

			// The name of this function must be "Lighting" + "what we have written after 'surf' in #pragma if it's different from defaults
			// such as 'Lambert'"
			// The s is a SurfaceOutput structure, the lightDir is the direction light is coming and atten is an attenuation value
			half4 LightingCelShading(SurfaceOutput s, fixed3 lightDir, fixed3 atten)
			{
				half diff = dot(s.Normal, lightDir);
				half h = diff * 0.48 + 0.5;
				half2 rh = h;
				half3 ramp = tex2D(_RampTex, rh).rgb;

				half4 c;
				
				// _LightColor0 comes with the 'includes' and provides information about all the lights affecting the object with this shader
				c.rgb = s.Albedo * _LightColor0.rgb * ramp;
				c.a = s.Alpha;

				return c;
			}

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo = tex2D(_MainTex, IN.texCoord);
			}

			// SURFACE MANAGEMENT -

		ENDCG
	}
	FallBack "Diffuse"
}
