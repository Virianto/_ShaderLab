Shader "Custom/Surface/Lighting/ColorCelShading" 
{
	// This surface shader paints an object in a narrow gradient of color depending on light incidence and texture provided
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569368?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Texture("Texture", 2D) = "white" {}
	}

	SubShader
	{
		CGPROGRAM

		float4 _Color;
		sampler2D _Texture;

		#pragma surface surf CelShading

		// The name of this function must be "Lighting" + "what we have written after 'surf' in #pragma if it's different from defaults
		// such as 'Lambert'"
		// The s is a SurfaceOutput structure, the lightDir is the direction light is coming and atten is an attenuation value
		half4 LightingCelShading(SurfaceOutput s, fixed3 lightDir, fixed3 atten)
		{
			float diff = dot(s.Normal, lightDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			float3 ramp = tex2D(_Texture, rh).rgb;

			float4 c;

			// _LightColor0 comes with the 'includes' and provides information about all the lights affecting the object with this shader
			c.rgb = s.Albedo * _LightColor0.rgb * ramp;
			c.a = s.Alpha;

			return c;
		}

		struct Input
		{
			float3 worldPos;
			float2 uv_TextureA;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
