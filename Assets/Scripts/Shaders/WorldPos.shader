Shader "GD3/WorldPosTransparency" {
  Properties {
    _center ("Center", Vector) = (0, 0, 0, 0)
    _size ("Size", Float) = 0
  }
  SubShader {
    Blend SrcAlpha OneMinusSrcAlpha
    Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
    CGPROGRAM

    #pragma surface surf Lambert alpha

    uniform float3 _center;
    uniform float _size;

    struct Input {
        float3 worldPos;
    };

    // Afstand tussen 2 punten (pythagoras op 3 assen)
    float distance(float3 a, float3 b) {
      float x = (a[0] - b[0]) * (a[0] - b[0]);
      float y = (a[1] - b[1]) * (a[1] - b[1]);
      float z = (a[2] - b[2]) * (a[2] - b[2]);
      return sqrt(x + y + z);
    }

    // functie om te checken of je binnen een bepaalde range bent
    bool bounded(float3 a) {
      return distance(a, _center) < _size;
    }

    // Bereken de afstand vanaf een bepaald center punt in de 3D wereld
    void surf (Input IN, inout SurfaceOutput o) {
      o.Alpha = 0;
      if (bounded(IN.worldPos)) {
        float partial = (_size - distance(IN.worldPos, _center)) / _size;
        o.Albedo = fixed3(partial, partial, partial);
        o.Alpha = partial;
      }
    }

    ENDCG
  }
  Fallback "Diffuse"
}