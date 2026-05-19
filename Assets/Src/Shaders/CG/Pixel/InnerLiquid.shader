Shader "Custom/Pixel/Advanced/InnerLiquid"
{
	Properties
	{
		[Header(Main properties)]
		_MainColor ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_FillingLevel("Filling level", Range(-1,2)) = 0.5		
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimPower("RimPower", Range(0,3)) = 0.05

		[Header(Surface properties)]
		_FoamWidth("Foam width", Range(0,1)) = 0.05
		_TopColor("Top Color", Color) = (1,1,1,1)
		_FoamColor("Foam Color", Color) = (1,1,1,1)		
	}

	SubShader
	{
		ZWrite On	
		Cull Off
		AlphaToMask On

		Pass
		{
			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				half _RimPower;
				half _FoamWidth;
				half _FillingLevel;

				fixed4 _MainColor;
				fixed4 _RimColor;
				fixed4 _TopColor;
				fixed4 _FoamColor;
				

				sampler2D _MainTex;
				fixed4 _MainTex_ST; // Needed for TRANSFORM_TEX(v.texcoord, _MainTex)

				struct appdata
				{
					fixed4 vertex : POSITION;
					fixed3 normal : NORMAL;
					fixed2 uv : TEXCOORD0;
				};

				struct v2f
				{
					fixed4 pos : SV_POSITION;
					fixed3 normal : NORMAL;
					fixed3 viewDir : COLOR;					
					fixed2 uv : TEXCOORD0;
					fixed fillEdge : TEXCOORD1;
				};							

				v2f vert (appdata v)
				{
					v2f o;
				
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);		

					float3 worldPos = mul(unity_ObjectToWorld, v.vertex.xyz);
					o.fillEdge = 1 - ((worldPos.y * -1) + _FillingLevel);

					o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
					o.normal = v.normal;

					return o;
				}
			
				// *fixed facingCamera : VFACE
				// Works as a boolean which tells us wether a vertex is facing main camera or not
				fixed4 frag (v2f i, fixed facingCamera : VFACE) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv) * _MainColor;

					// rim light				   
					fixed dotProduct = 1 - pow(dot(i.normal, i.viewDir), _RimPower);
					fixed4 RimResult = smoothstep(0.5, 1.0, dotProduct);
					RimResult *= _RimColor;
 
					// foam edge
					fixed4 foam = (step(i.fillEdge, 0.5) - step(i.fillEdge, (0.5 - _FoamWidth)));
					fixed4 foamColored = foam * _FoamColor;

					// rest of the liquid
					fixed4 result = step(i.fillEdge, 0.5) - foam;
					fixed4 resultColored = result * col;

					// both together, with the texture
					fixed4 finalResult = resultColored + foamColored;
					finalResult.rgb += RimResult;

					// color of backfaces/ top
					fixed4 topColor = _TopColor * (foam + result);

					return facingCamera > 0 ? finalResult : topColor;
				}

			ENDCG
		}		
	}
	FallBack "Diffuse"
}
