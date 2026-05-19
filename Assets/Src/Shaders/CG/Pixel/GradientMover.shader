// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32719,y:32712,varname:node_4013,prsc:2|diff-8528-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32049,y:32624,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Smoothstep,id:6524,x:31640,y:33008,varname:node_6524,prsc:2|A-9211-OUT,B-8707-OUT,V-9593-OUT;n:type:ShaderForge.SFN_Vector1,id:9211,x:31456,y:33098,varname:node_9211,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Smoothstep,id:159,x:31644,y:33286,varname:node_159,prsc:2|A-9211-OUT,B-8707-OUT,V-8956-OUT;n:type:ShaderForge.SFN_OneMinus,id:8956,x:31396,y:33286,varname:node_8956,prsc:2|IN-9593-OUT;n:type:ShaderForge.SFN_OneMinus,id:5407,x:32070,y:33081,varname:node_5407,prsc:2|IN-6516-OUT;n:type:ShaderForge.SFN_Add,id:6516,x:31899,y:33081,varname:node_6516,prsc:2|A-6524-OUT,B-159-OUT;n:type:ShaderForge.SFN_Clamp01,id:7426,x:32232,y:33081,varname:node_7426,prsc:2|IN-5407-OUT;n:type:ShaderForge.SFN_Lerp,id:8528,x:32450,y:32763,varname:node_8528,prsc:2|A-1304-RGB,B-6421-RGB,T-7426-OUT;n:type:ShaderForge.SFN_Color,id:6421,x:32050,y:32814,ptovrint:False,ptlb:node_6421,ptin:_node_6421,varname:node_6421,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Slider,id:8707,x:31299,y:33185,ptovrint:False,ptlb:Scan Width,ptin:_ScanWidth,varname:node_8707,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.5,cur:0.6281422,max:1;n:type:ShaderForge.SFN_Time,id:5169,x:30148,y:33007,varname:node_5169,prsc:2;n:type:ShaderForge.SFN_Multiply,id:1552,x:30425,y:33119,varname:node_1552,prsc:2|A-5169-T,B-328-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1817,x:29953,y:33231,ptovrint:False,ptlb:OffsetSpeed,ptin:_OffsetSpeed,varname:node_1817,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Frac,id:7314,x:32310,y:33283,varname:node_7314,prsc:2|IN-7426-OUT;n:type:ShaderForge.SFN_Frac,id:9593,x:31091,y:33116,varname:node_9593,prsc:2|IN-9143-OUT;n:type:ShaderForge.SFN_Multiply,id:9143,x:30927,y:33116,varname:node_9143,prsc:2|A-3753-OUT,B-4061-OUT;n:type:ShaderForge.SFN_Vector1,id:4061,x:30685,y:33307,varname:node_4061,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Add,id:3753,x:30699,y:33096,varname:node_3753,prsc:2|A-2783-OUT,B-1552-OUT;n:type:ShaderForge.SFN_ComponentMask,id:2783,x:30716,y:32768,varname:node_2783,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-8117-OUT;n:type:ShaderForge.SFN_Subtract,id:8117,x:30530,y:32768,varname:node_8117,prsc:2|A-468-XYZ,B-3246-XYZ;n:type:ShaderForge.SFN_FragmentPosition,id:468,x:30317,y:32651,varname:node_468,prsc:2;n:type:ShaderForge.SFN_ObjectPosition,id:3246,x:30315,y:32882,varname:node_3246,prsc:2;n:type:ShaderForge.SFN_Negate,id:328,x:30162,y:33207,varname:node_328,prsc:2|IN-1817-OUT;proporder:1304-6421-8707-1817;pass:END;sub:END;*/

Shader "Arth/GradientMoverViaPos" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _node_6421 ("node_6421", Color) = (1,0,0,1)
        _ScanWidth ("Scan Width", Range(0.5, 1)) = 0.6281422
        _OffsetSpeed ("OffsetSpeed", Float ) = 1
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform float4 _node_6421;
            uniform float _ScanWidth;
            uniform float _OffsetSpeed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float node_9211 = 0.5;
                float4 node_5169 = _Time;
                float node_9593 = frac((((i.posWorld.rgb-objPos.rgb).g+(node_5169.g*(-1*_OffsetSpeed)))*0.5));
                float node_7426 = saturate((1.0 - (smoothstep( node_9211, _ScanWidth, node_9593 )+smoothstep( node_9211, _ScanWidth, (1.0 - node_9593) ))));
                float3 diffuseColor = lerp(_Color.rgb,_node_6421.rgb,node_7426);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform float4 _node_6421;
            uniform float _ScanWidth;
            uniform float _OffsetSpeed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float node_9211 = 0.5;
                float4 node_5169 = _Time;
                float node_9593 = frac((((i.posWorld.rgb-objPos.rgb).g+(node_5169.g*(-1*_OffsetSpeed)))*0.5));
                float node_7426 = saturate((1.0 - (smoothstep( node_9211, _ScanWidth, node_9593 )+smoothstep( node_9211, _ScanWidth, (1.0 - node_9593) ))));
                float3 diffuseColor = lerp(_Color.rgb,_node_6421.rgb,node_7426);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
