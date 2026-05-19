Shader "Custom/Surface/Lighting/TextureCelShading" 
{
	// This surface shader paints an object with its texture affected for a toon lighting
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569368?start=0

	Properties
	{
		_MainTexture("Main texture", 2D) = "white" {}
		_RampTexture("Ramp texture", 2D) = "white" {}
	}

	SubShader
	{
		CGPROGRAM

		sampler2D _MainTexture;
		sampler2D _RampTexture;

		#pragma surface surf CelShading

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
			float2 uv_MainTexture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}