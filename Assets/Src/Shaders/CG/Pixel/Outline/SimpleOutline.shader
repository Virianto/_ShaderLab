Shader "Custom/Mixed/Outline/SimpleOutline"
{
	// This pixel shader draws a colored line out of the object's shape allowing you to control width and color
	// More documentation can be found in Udemy's course: https://indra.udemy.com/unity-shaders/learn/v4/t/lecture/8604244?start=0

	Properties
	{
		_ObjectColor("Object Color", Color) = (1,1,1,1)
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 0.5)) = 0.05
	}

	SubShader
	{
		// FIRST Paint the object itself in a simple way (could use any other surface filter like Cel Shading):

		CGPROGRAM

		#pragma surface surf Lambert
				
		fixed4 _ObjectColor;
			
		struct Input
		{
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _ObjectColor;
		}
			
		ENDCG
		
		// SECOND create the outline effect:

		Pass
		{
			// Remove those vertices which are not facing the camera frontally (otherwise, outlining would hide the object behind it)
			Cull Front

			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				float _OutlineWidth;
				fixed4 _OutlineColor;

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 color : COLOR;
				};

				v2f vert(appdata v)
				{
					v2f o;	

					o.pos = UnityObjectToClipPos(v.vertex);

					// Calculate the world normals instead of vertices normals (by multiplying the normal and the matrix)
					float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
					float2 offset = TransformViewToProjection(norm.xy);
					o.pos.xy += offset * o.pos.z * _OutlineWidth;
					o.color = _OutlineColor;

					return o;
				}
				
				half4 frag(v2f i) : SV_Target
				{
					return i.color;
				}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}