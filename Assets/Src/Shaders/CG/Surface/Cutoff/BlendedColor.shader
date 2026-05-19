Shader "Custom/Surface/Cutoff/BlendedColor" 
{
	// This surface shader paints an smoothed interpolation between the two given colors
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8569306?start=30

	Properties
	{
		_Top ("Top", Range(0.3, 2)) = 1
		_Bottom("Bottom", Range(0, 2)) = 1

		_ColorA("Color A", Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		half _Top;
		half _Bottom;

		float4 _ColorA;
		float4 _ColorB;

		struct Input
		{
			float3 worldPos;
		};		

		void surf(Input IN, inout SurfaceOutput o)
		{		
			half3 l = lerp(_ColorB.rgb, _ColorA.rgb, (IN.worldPos.y - _Bottom) / (_Top - _Bottom));
			o.Albedo = IN.worldPos.y > _Top ? _ColorA.rgb : IN.worldPos.y < _Bottom ? _ColorB.rgb : l;			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
