Shader "GD3/EdgeMultiPass" {
  Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _OutlineSize ("Outline Size", float) = 0.05
    _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
  }
  SubShader {

    Tags { "RenderType" = "Opaque" }

    CGPROGRAM
      #pragma surface surf Standard

      sampler2D _MainTex;

      struct Input {
        float2 uv_MainTex;
      };

      void surf (Input IN, inout SurfaceOutputStandard o) {
        fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
        o.Albedo = c.rgb;
      }
    ENDCG

    Cull Front
   	
    CGPROGRAM
      #pragma surface surf Standard vertex:vert

      float4 _OutlineColor;
      float _OutlineSize;

      void vert (inout appdata_full v) {
        v.vertex.xyz += v.normal * _OutlineSize;
      }

      struct Input {
        float2 uv_MainTex;
      };

      void surf (Input IN, inout SurfaceOutputStandard o) {
        o.Albedo = _OutlineColor.rgb;
      }
    ENDCG
  }
  FallBack "Diffuse"
}