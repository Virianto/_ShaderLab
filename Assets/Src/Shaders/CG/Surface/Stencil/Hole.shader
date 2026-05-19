Shader "Custom/Surface/Stencil/Hole" 
{
	// This surface shader is meant to work as a hole of transparency for other surfaces (must work together)
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8602726?start=0

	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		// This will automatically tell the GPU to process this shader right before geometry so it knows what to hide
		Tags{"Queue" = "Geometry-1"}

		// Always place Stencil options between Tags and CGPROGRAM block
		Stencil
		{
			Ref 1			// ID of this shader in Stencil buffer (several shaders can have the same for comparisons)
			Comp always		// Look for other "Ref" with the same value as this one
			Pass replace	// Remove those fragments from that geometry
		}

		CGPROGRAM

		// We have added "alpha : fade" after de usual Lambert pragma in order to process transparency
		#pragma surface surf Lambert alpha:fade

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
