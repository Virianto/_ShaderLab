Shader "Custom/Surface/Lighting/LambertLighting" 
{
	// This surface shader simply paints a surface as it should with a Lambert configuration
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569368?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Texture("Texture", 2D) = "white" {}
	}

		SubShader
	{
		CGPROGRAM

		#pragma surface surf BasicLambert

		// The name of this function must be "Lighting" + "what we have written after 'surf' in #pragma if it's different from defaults
		// such as 'Lambert'"
		// The s is a SurfaceOutput structure, the lightDir is the direction light is coming and atten is an attenuation value
		half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten) 
		{
			// Here we get the dot product between the surface normal and the direction light is coming
			half NdotL = dot(s.Normal, lightDir);
			half4 c;

			// _LightColor0 comes with the 'includes' and provides information about all the lights affecting the object with this shader
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
			c.a = s.Alpha;

			return c;
		}

		float4 _Color;
		sampler2D _TextureA;

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
