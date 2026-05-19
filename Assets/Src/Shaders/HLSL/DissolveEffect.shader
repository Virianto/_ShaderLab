Shader "Custom/HLSL/DissolveEffect"
{
    Properties
    {
        [Header(Main drawing options)]

        _MainColor("Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white" {}
		_AlphaThreshold("Alpha Threshold", Range(0, 1)) = 0

        [Header(Dissolve drawing options)]

        _DissolveAmount("Dissolve Amount", Range(0, 1)) = 0
        [HDR]_DissolveLineColor("Dissolve Line Color", Color) = (1,1,1,1)
        _DissolveLineWidth("Dissolve Line Width", Range(0, 1)) = 0
        _DissolveTex("Dissolve texture", 2D) = "white" {}
    }

    SubShader
    {        
		Tags 
		{ 
			"RenderType"="Transparent"
			"Queue" = "Transparent"
			"RenderPipeline" = "UniversalRenderPipeline" 
		}

		Blend SrcAlpha OneMinusSrcAlpha

        Pass
		{			
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag            
          
			#include "HLSLSupport.cginc"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			half4 _MainColor;
			sampler2D _MainTex;			
			half _AlphaThreshold;

			fixed _DissolveAmount;
			fixed _DissolveLineWidth;
			half4 _DissolveLineColor;
			sampler2D _DissolveTex;

			struct appdata
			{
				half4 vertex : POSITION;				
				half2 uv : TEXCOORD0;
			};

			struct v2f
			{
				half4 vertex : SV_POSITION;
				half2 uv : TEXCOORD0;
			};


			v2f vert(appdata v)
			{
				v2f o;				

				o.uv = v.uv;

				o.vertex = TransformObjectToHClip(v.vertex.xyz);	
				
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 dissolveValue;
				fixed4 c;

				dissolveValue = tex2D(_DissolveTex, i.uv);

				c = (_DissolveAmount + _DissolveLineWidth > dissolveValue.r) ? _DissolveLineColor : tex2D(_MainTex, i.uv) * _MainColor;

				clip(c.a <= _AlphaThreshold ? -1 : 1);
				clip((_DissolveAmount < dissolveValue.r) ? 1 : -1);
				
				return c;
			}

            ENDHLSL
        }
    }
}
