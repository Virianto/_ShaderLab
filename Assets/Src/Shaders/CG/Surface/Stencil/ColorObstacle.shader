Shader "Custom/Surface/Stencil/ColorObstacle" 
{
	// This surface shader is meant to work as an obstacle penetrated by the "Hole" shader
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8602726?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags{"Queue" = "Geometry"}

		// Always place Stencil options between Tags and CGPROGRAM block
		Stencil
		{
			Ref 1			// ID of this shader in Stencil buffer (several shaders can have the same for comparisons)
			Comp notequal	// Look for other "Ref" in Stencil buffer which are different
			Pass keep		// Paint these fragments
		}

		CGPROGRAM

		#pragma surface surf Lambert

		float4 _Color;

		struct Input
		{
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
