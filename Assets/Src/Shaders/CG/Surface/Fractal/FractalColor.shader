Shader "Custom/Surface/Fractal/FractalColor" 
{
	// This surface shader paints a different color depending on a fractal value
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569306?start=645

	Properties
	{
		_ColorA("Color A", Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		float4 _ColorA;
		float4 _ColorB;

		struct Input
		{
			float3 worldPos;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = frac(IN.worldPos.x * 5) > 0.5 ? _ColorA.rgb : _ColorB.rgb;	// Can write o.Emssion instead of Albedo for unlit colors
		}
		ENDCG
	}
	FallBack "Diffuse"
}
