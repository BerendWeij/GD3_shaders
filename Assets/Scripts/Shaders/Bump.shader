Shader "GD3/BumpShader" {

	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex ("Onze normal map", 2D) = "bump" {}
		_BumpMultiplier ("Bump Multiplier", Range(0.0001,2)) = 1
	}

	SubShader {

		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Standard

		sampler2D _MainTex;
		sampler2D _BumpTex;
		half _BumpMultiplier;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;

			// float3 UnpackNormal - text2D - multiplier
			float3 n = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));

			// We kunnen de normal nog wat verder aanstippen
			half _BumpIntensity = 1/ _BumpMultiplier;
			// hoe lager de z, des te hoger de x en y na het normaliseren. Daardoor krijgen we nog harder contrast
            n.z = n.z * _BumpIntensity;

			o.Normal = normalize(n);
		}
		ENDCG
	}
	FallBack "Diffuse"
}