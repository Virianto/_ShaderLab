Shader "Venat/UVDisplayer"
{
	// Paints the object following the UV coordinates, this way we can
	// know how textures will fit on its surface.
	// Only green and red are shown since UV corresponds to the first
	// two variables of half4 : COLOR --> R G B A
	SubShader
	{		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertexPos : POSITION;
				fixed2 texCoord : TEXCOORD0;	// This could be float4, or half4, or fixed4... but fixed2 is the most optimus
			};

			struct v2f
			{
				float4 vertexPos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertexPos = UnityObjectToClipPos(v.vertexPos);

				// We need fixed4 here because we're working with 4 values of type "fixed"
				o.uv = fixed4(v.texCoord.xy, 0, 0);					

				return o;
			}
			
			// The returned value of this fragment function will be a half4 attribute related to the color hardware resource
			half4 frag (v2f i) : COLOR
			{
				// CG function 'frac' returns the fractional portion of a scalar or each vector component
				half4 c = frac(i.uv);									
				return c;
			}
			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}