Shader "Custom/Surface/Cutoff/TextureCutoff" 
{
	// This surface shader paints a different texture depending on the object's vertex position
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569306?start=30

	Properties
	{
		_TextureA("Texture A", 2D) = "white" {}
		_TextureB("Texture B", 2D) = "white" {}
		_TextureC("Texture C", 2D) = "white" {}
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		sampler2D _TextureA;
		sampler2D _TextureB;
		sampler2D _TextureC;

		struct Input
		{
			float3 worldPos;
			float2 uv_TextureA;
			float2 uv_TextureB;
			float2 uv_TextureC;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = IN.worldPos.y > 1 ? tex2D(_TextureA, IN.uv_TextureA).rgb : IN.worldPos.y > 0.5 ? tex2D(_TextureB, IN.uv_TextureB).rgb : tex2D(_TextureC, IN.uv_TextureC).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
