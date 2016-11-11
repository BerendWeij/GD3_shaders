Shader "GD3/MultipleScreens"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
	}
	SubShader
	{
		// Geen culling en niet bijhouden waar de pixels zich in 3d bevinden
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM

			// we geven door dat we een vert functie hebben en een fragment functie
			#pragma vertex vert
			#pragma fragment frag

			// we willen wat 'extended' functies gebruiken zoals UNITY_MATRIX_MVP, dus: includen die hap
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				// we moeten de model/vertex coordinaten omrekenen naar screen coordinaten
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _DisplaceTex;

			float4 frag (v2f i) : SV_Target
			{
				// we pakken de pixels op de plek van de uv mapping, maar dan aangepast met wat we hierboven hebben berekent
				float4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}