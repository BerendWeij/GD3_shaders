﻿Shader "GD3/CustomLambert" {
        Properties {
            _MainTex ("Texture", 2D) = "white" {}
        }
        SubShader {
            Tags { "RenderType" = "Opaque" }
            CGPROGRAM
              #pragma surface surf SimpleLambert
    
              half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) {
                  half NdotL = dot (s.Normal, lightDir);
//                  NdotL = NdotL / 2 + 0.5;
                  NdotL = max(sign(NdotL - 0.5), 0);
                  half4 c;
                  c.rgb = s.Albedo * _LightColor0.rgb * NdotL;
                  c.a = s.Alpha;
                  return c;
              }
      
            struct Input {
                float2 uv_MainTex;
            };
            
            sampler2D _MainTex;
            
            void surf (Input IN, inout SurfaceOutput o) {
                o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            }
            ENDCG
        }
        Fallback "Diffuse"
    }