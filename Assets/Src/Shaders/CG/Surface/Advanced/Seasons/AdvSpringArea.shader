Shader "Custom/Surface/Seasons/AdvSpringArea"
//{
//    Properties
//	{
//		_MainTexture("Texture", 2D) = "white"{}
//
//		_DispTexture("Displacement texture", 2D) = "white"{}
//		_Displacement("Displacement", Range(0, 2)) = 1
//		_Speed("Speed", Range(-2, 2)) = 1
//
//		[Toggle]
//		_DarkRim("Darken edge", Float) = 0
//		_Color("Color", Color) = (1,1,1,1)
//		_Softening("Softening", Range(0.2, 5)) = 2
//	}
//
//	SubShader
//	{
//		Pass
//		{
//			Tags{"Queue" = "Transparent"}
//
//			Lighting Off
//			ZWrite On
//			Cull Off
//
//			CGPROGRAM
//
//			#pragma vertex vert //alpha:fade
//			#pragma fragment frag
//
//			#include "UnityCG.cginc"
//
//			sampler2D _MainTexture;
//			sampler2D _DispTexture;
//			sampler2D _CameraDepthTexture;
//
//			half _Displacement;
//			half _Speed;
//
//			float _DarkRim;
//			float4 _Color;
//			half _Softening;
//
//			struct appdata
//			{
//				half4 vertex : POSITION;
//				half3 normal : NORMAL;
//				half2 uv : TEXCOORD0;
//			};
//
//			struct v2f
//			{
//				half4 vertex : SV_POSITION;
//				half2 uv : TEXCOORD0;
//				half3 viewDir : TEXCOORD1;
//				half3 normalDir : TEXCOORD2;
//			};
//
//			v2f vert(appdata v)
//			{
//				v2f o;
//
//				o.vertex = UnityObjectToClipPos(v.vertex);
//				//o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
//
//				half d = tex2Dlod(_DispTexture, float4(o.vertex.x, o.vertex.y + (_Time.y * _Speed), 0, 0));
//				//UNITY_INITIALIZE_OUTPUT(Input, o);
//				o.vertex.xyz += _Displacement * v.normal * d;
//
//				o.normalDir = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz); // normal direction
//				//o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
//
//				//eye space depth of the vertex
//				//COMPUTE_EYEDEPTH(o.vertex.z);
//				return o;
//			}
//
//			fixed4 frag(v2f i/*, fixed face : VFACE*/) : SV_Target
//			{
//				fixed4 c;
//
//				half4 rim = pow(1 - dot(normalize(i.viewDir), i.normalDir), _Softening);
//				rim = _DarkRim ? rim : 1 - rim;				
//
//				//c.Alpha = rim > 0.1 ? pow(rim, _Softening) : 1;
//
//				//c.Albedo = _Color.rgb * pow(rim, _Softening) * tex2D(_MainTexture,  IN.uv_MainTexture).rgb;
//				return rim;
//			}
//			ENDCG
//		}		
//	}
//	FallBack "Diffuse"
//}

{
	Properties
	{
		[Header(Jeje)]

		_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}

		[Header(Jaja)]

		_Displacement("Displacement", Range(0, 2)) = 1
		_Speed("Speed", Range(-2, 2)) = 1

		_Fresnel("Fresnel Intensity", Range(0,200)) = 3.0
		_FresnelWidth("Fresnel Width", Range(0,2)) = 3.0
		_Distort("Distort", Range(0, 100)) = 1.0
		_IntersectionThreshold("Highlight of intersection threshold", range(0,1)) = .1 //Max difference for intersections
		_ScrollSpeedU("Scroll U Speed",float) = 2
		_ScrollSpeedV("Scroll V Speed",float) = 0
		//[ToggleOff]_CullOff("Cull Front Side Intersection",float) = 1
	}
	SubShader
	{ 
		Tags{ "Queue" = "Overlay" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
	
		GrabPass { "_GrabTexture" }
			
		Pass
		{
			Lighting Off ZWrite On
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
	
			struct appdata
			{
				fixed4 vertex : POSITION;
				fixed4 normal: NORMAL;
				fixed3 uv : TEXCOORD0;
			};
	
			struct v2f
			{				
				fixed4 vertex : SV_POSITION;
				fixed2 uv : TEXCOORD0;
				fixed3 rimColor :TEXCOORD1;
				fixed4 screenPos: TEXCOORD2;
			};

			half _Displacement;
			half _Speed;
	
			sampler2D _MainTex, _CameraDepthTexture, _GrabTexture;
			fixed4 _MainTex_ST,_MainColor,_GrabTexture_ST, _GrabTexture_TexelSize;
			fixed _Fresnel, _FresnelWidth, _Distort, _IntersectionThreshold, _ScrollSpeedU, _ScrollSpeedV;
	
			v2f vert (appdata v)
			{
				v2f o;				
	
				o.vertex = UnityObjectToClipPos(v.vertex);

				half d = tex2Dlod(_MainTex, float4(o.vertex.x, o.vertex.y + (_Time.y * _Speed), 0, 0));
				//UNITY_INITIALIZE_OUTPUT(Input, o);
				o.vertex.xyz += _Displacement * v.normal * d;
	
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	
				//scroll uv
				o.uv.x += _Time * _ScrollSpeedU;
				o.uv.y += _Time * _ScrollSpeedV;
	
				//fresnel 
				fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				fixed dotProduct = 1 - saturate(dot(v.normal, viewDir));
				o.rimColor = smoothstep(1 - _FresnelWidth, 1.0, dotProduct) * .5f;
				o.screenPos = ComputeScreenPos(o.vertex);
	
				//eye space depth of the vertex
				COMPUTE_EYEDEPTH(o.screenPos.z); 
									
				return o;
			}
				
			fixed4 frag (v2f i,fixed face : VFACE) : SV_Target
			{
				//intersection
				fixed intersect = saturate((abs(LinearEyeDepth(tex2Dproj(_CameraDepthTexture,i.screenPos).r) - i.screenPos.z)) / _IntersectionThreshold);
	
				fixed3 main = tex2D(_MainTex, i.uv);
					
				//distortion
				i.screenPos.xy += (main.rg * 2 - 1) * _Distort * _GrabTexture_TexelSize.xy;
				fixed3 distortColor = tex2Dproj(_GrabTexture, i.screenPos);
				distortColor *= _MainColor * _MainColor.a + 1;
	
				//intersect hightlight
				i.rimColor *= intersect * clamp(0,1,face);
				main *= _MainColor * pow(_Fresnel,i.rimColor) ;
					
				//lerp distort color & fresnel color
				main = lerp(distortColor, main, i.rimColor.r);
				main += (1 - intersect) * (face > 0 ? .03:.3) * _MainColor * _Fresnel;
				return fixed4(main, 0.9);
			}
			ENDCG
		}
	}
}
