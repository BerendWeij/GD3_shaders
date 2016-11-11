Shader "GD3/Rim" {
    Properties {
      _MainTex ("Texture", 2D) = "white" {}
      _BumpTex ("Bump Texture", 2D) = "bump" {}
      _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader {

      Tags { "RenderType" = "Opaque" }

      CGPROGRAM

      #pragma surface surf Standard

      sampler2D _MainTex;
      sampler2D _BumpTex;
      float4 _RimColor;
      float _RimPower;

      struct Input {
          float2 uv_MainTex;
          float2 uv_BumpTex;
          // normal richting de camera
          float3 viewDir;
      };

      void surf (Input IN, inout SurfaceOutputStandard o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
          o.Normal = UnpackNormal (tex2D (_BumpTex, IN.uv_BumpTex));
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          o.Emission = _RimColor.rgb * pow (rim, _RimPower);
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }