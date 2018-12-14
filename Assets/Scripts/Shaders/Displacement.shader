Shader "GD3/Displacement"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0,0.1)) = 1
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
						
			// declaratie van de variabelen die we ook vanuit de Unity editor doorkrijgen
			sampler2D _MainTex;
			sampler2D _DisplaceTex;
			float _Magnitude;
			
			
			

            // de values die we in de vert functie binnen krijgen per vertex
			struct appdata
			{
				float2 uv : TEXCOORD0;
				float4 vertex : POSITION;
			};
			
			// structuur met values die we aan de frag functie willen kunnen doorgeven
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			
			
			
			
			
            // Vert functie. Deze gaat voor elke vertex af
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); // we moeten de model/vertex coordinaten omrekenen naar screen coordinaten
				o.uv = v.uv;
				return o;
			}
			
			// frag functie. Deze gaat voor elke potentiele pixel af
			float4 frag (v2f i) : SV_Target
			{
				// we pakken de RG (van RGB) als het getal voor hoeveel we willen displacen.
				// dit is een waarde van 0-1 voor R (x) en 0-1 voor G (y)
				float2 disp = tex2D(_DisplaceTex, i.uv).xy;

				// door deze berekening gaan we van 0 tot 1 naar -1 tot 1 (vermenigvuldigt bij magnitude om het instelbaar te maken)
				disp = ((disp * 2) - 1) * _Magnitude;

				// we pakken de pixels op de plek van de uv mapping, maar dan aangepast met wat we hierboven hebben berekent
				float4 col = tex2D(_MainTex, i.uv + disp);
				return col;
			}
			ENDCG
		}
	}
}