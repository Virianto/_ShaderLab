Shader "Custom/HLSL/StencilFX/LitMaskableObject"
{
    Properties
    {
        [Header(Stencil reference)]

        _StencilRef("Stencil Reference", Int) = 0

        [Header(Regular material properties)]

        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }

    SubShader
    {
        Tags 
        { 
            "RenderPipeline" = "UniversalPipeline"            
            "RenderType"="Opaque"         
            "Queue" = "Geometry"
        }       

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
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"            

            sampler2D_half _MainTex;
            half4 _MainTex_ST;

            half4 _Color;

            struct appdata 
            {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
            };

            struct v2f 
            {
                half4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 normal : TEXCOORD1;
                half4 worldPos : TEXCOORD2;
            };

            // Custom function for lighting calculation
            half3 ApplySimpleLambertLighting(half4 iPos, half3 iNormal)
            {                
                Light mainLight = GetMainLight(iPos);

                half NdotL = saturate(dot(normalize(_MainLightPosition.xyz), iNormal));
                half3 ambient = SampleSH(iNormal);

                return (NdotL * _MainLightColor.rgb * mainLight.shadowAttenuation + ambient);
            }

            v2f vert(appdata v) 
            {
                v2f o;

                o.pos = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
                o.normal = normalize(mul((half3x3)unity_WorldToObject, v.normal));

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
                o.worldPos = GetShadowCoord(vertexInput);
                
                return o;
            }
            
            half4 frag(v2f i) : COLOR 
            {
                half4 result = tex2D(_MainTex, i.uv) * _Color;
                                
                // Lighting  
                result.rgb *= ApplySimpleLambertLighting(i.worldPos, i.normal);                                                                                

                // Set transparency from texture or sprite
                clip(result.a == 0 ? -1 : 1);

                return result;
            }
            ENDHLSL
        }
    } 
    FallBack "Diffuse"
}