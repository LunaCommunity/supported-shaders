Shader "Luna/Outline2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth ("Outline Width", Range(0, 4)) = 0.03
    }
    SubShader
    {
        Tags { "RenderType"="Geometry" "Queue"="Transparent" }
        LOD 200
        Cull Back

        //the outline pass
        Pass{
            ZWrite Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            fixed4 _OutlineColor;
            half _OutlineWidth;

            v2f vert(appdata input)
            {    
                input.vertex += float4(input.normal * _OutlineWidth, 1);
                v2f output;
                output.pos = UnityObjectToClipPos(input.vertex);
                return output;
            }

            fixed4 frag(v2f input) : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }

        //Now the normal texture pass as a standard surface shader
        ZWrite On
        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            o.Albedo = col;
        }
        ENDCG
    }
    
    //Incase we don't support anything in the above passes
    FallBack "Standard"
}
