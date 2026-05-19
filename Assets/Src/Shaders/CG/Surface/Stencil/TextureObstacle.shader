Shader "Custom/Surface/Stencil/TextureObstacle" 
{
	// This surface shader is meant to work as an obstacle penetrated by the "Hole" shader
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8602726?start=0

	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
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

		sampler2D _MainTexture;

		struct Input
		{
			float3 viewDir;
			float2 uv_MainTexture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
