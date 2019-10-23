Shader "Custom/radiablur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_BlurCenter("BlurCenter",Color) = (0.5,0.5,0.5)
		_BlurFactor("BlurFactor", Float) = 0.01
		_LerpFactor("LerpFactor", Float) = 0.5
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				half3 _BlurCenter;
				half _BlurFactor;
				half _LerpFactor;
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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
				half2 dir = _BlurCenter - i.uv;
				half distance = length(dir);
				half4 color = tex2D(_MainTex, i.uv);
				half4 blurcolor = color;
				for (int k = 1;k < 5;k++)
				{
					blurcolor += tex2D(_MainTex, i.uv + dir * k*_BlurFactor);
				}
                return lerp(color, blurcolor/5, _LerpFactor*distance);
            }
            ENDCG
        }
    }
}
