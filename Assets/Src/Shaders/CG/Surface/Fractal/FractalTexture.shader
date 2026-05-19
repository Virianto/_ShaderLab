Shader "Custom/Surface/Fractal/FractalTexture" 
{
	// This surface shader switches between two textures depending on a fractal value
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569306?start=645

	Properties
	{
		_TextureA("Texture A", 2D) = "white" {}
		_TextureB("Texture B", 2D) = "white" {}
	}

		SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		sampler2D _TextureA;
		sampler2D _TextureB;

		struct Input
		{
			float3 worldPos;
			float2 uv_TextureA;
			float2 uv_TextureB;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = frac(IN.worldPos.x * 5) > 0.5 ? tex2D(_TextureA, IN.uv_TextureA) : tex2D(_TextureB, IN.uv_TextureB);
		}
		ENDCG
	}
		FallBack "Diffuse"
}
