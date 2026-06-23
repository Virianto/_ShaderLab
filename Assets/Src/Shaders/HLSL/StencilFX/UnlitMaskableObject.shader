Shader "_ViriantoTem/HLSL/StencilFX/UnlitMaskableObject"
{
    Properties 
    {
        [Header(Stencil reference)]

        _StencilRef("Stencil Reference", Int) = 0

        [Header(Regular material properties)]

        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
    }

    SubShader 
    {
        Tags { "RenderType"="Opaque" }
        
        Stencil 
        {
            Ref[_StencilRef]
            Comp equal
            Pass keep
            Fail keep
        }

        Pass 
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            sampler2D_half _MainTex;
            half4 _MainTex_ST;

            half4 _Color;

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v) 
            {
                v2f o;
                o.pos = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            half4 frag(v2f i) : SV_Target 
            {
                half4 result = tex2D(_MainTex, i.uv) * _Color;

                // Set transparency from texture or sprite
                clip(result.a == 0 ? -1 : 1);

                return result;
            }
            ENDHLSL
        }
    } 
    FallBack "Diffuse"
}
