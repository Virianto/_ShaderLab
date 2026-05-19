Shader "Custom/Pixel/VertexExtrussion/SingleDirectionExtrussion"
{
	// This pixel shader generates a vertex displacement depending on the vector received

	Properties
	{
		[Freezing properties]

		_RegionColor("Region Color", Color) = (1,1,1,1)			
		_IceLength("Ice Length", Range(-3, 3)) = 0

		[Header(Gaze properties)]

		_GazedColor("Gazed Color", Color) = (1,1,1,1)

		_X("X", Range(-1, 1)) = 0
		_Y("Y", Range(-1, 1)) = 0
		_Z("Z", Range(-1, 1)) = 0

		_Tolerance("Tolerance", Range(-1,1)) = 0
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed _X;
			fixed _Y;
			fixed _Z;

			half _Tolerance;
			half _IceLength;

			fixed4 _RegionColor;
			fixed4 _GazedColor;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;		
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 viewDir : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
				half4 color : COLOR;
			};

			v2f vert (appdata v)
			{
				v2f o;
				fixed3 myVector;
				
				myVector = fixed3(_X, _Y, _Z);
				o.pos = UnityObjectToClipPos(v.vertex);
												
				// Normal direction in world position
				o.normalDir = normalize(mul(fixed4(v.normal, 0), unity_WorldToObject).xyz); 
				
				// Get a value which tells us if myVector and v.normal are facing each other (-><-) = -1 or not (<-<-) = 1	
				fixed d = dot(myVector, o.normalDir);

				half3 resultingColor = _RegionColor * d;

				// Set v.normal to v.vertex if you have hard normals
				float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));

				float2 offset = TransformViewToProjection(norm.xy);

				o.pos.xy += d >= _Tolerance ? (offset * o.pos.z * _IceLength) : 0;

				o.color.rgb = d <= _Tolerance ? _GazedColor : resultingColor;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}

			ENDCG
		}
	}
	// This should be commented during development to ensure we're working with our shader
	Fallback "Diffuse"
}