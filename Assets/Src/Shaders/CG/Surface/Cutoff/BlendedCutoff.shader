Shader "Custom/Surface/Cutoff/BlendedCutoff" 
{
	// This surface shader paints a different texture depending on the object's vertex position and tries
	// to give a smooth transition feelign between them
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569306?start=30

	Properties
	{
		_Top ("Top", Range(0.3, 2)) = 1
		_Bottom("Bottom", Range(0, 2)) = 1
		_TextureA("Texture A", 2D) = "white" {}
		_TextureB("Texture B", 2D) = "white" {}
		_TextureC("Texture C", 2D) = "white" {}
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		half _Top;
		half _Bottom;
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
			half3 a = tex2D(_TextureA, IN.uv_TextureA).rgb;
			half3 b = tex2D(_TextureB, IN.uv_TextureB).rgb;
			
			//half3 l = lerp(b, a, (IN.worldPos.y - _Bottom) / (_Top - _Bottom));
			half3 l = lerp(b, a, (IN.worldPos.y - _Bottom) / (_Top - _Bottom));

			o.Albedo = IN.worldPos.y > _Top ? a : IN.worldPos.y < _Bottom ? b : l;		
		}
		ENDCG
	}
	FallBack "Diffuse"
}
