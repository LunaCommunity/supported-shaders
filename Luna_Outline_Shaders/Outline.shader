Shader "Luna/Outline"
{
    Properties
    {
        _Color("Main Color", Color) = (0.5, 0.5, 0.5, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor("Outline color", Color) = (0,0,0,1)
        _OutlineWidth("Outline width", Range(1.0, 5.0)) = 1.01
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float3 normal: NORMAL;
    };

    struct v2f
    {
        float4 pos : POSITION;
        float3 normal : NORMAL;
    };

    float _OutlineWidth;
    float4 _OutlineColor;

    //render the normal mesh but slightly bigger based on the _OutlineWidth
    v2f vert(appdata v)
    {
        v.vertex.xyz *= _OutlineWidth;
        v2f o;

        //transform back to world space position
        o.pos = UnityObjectToClipPos(v.vertex);

        return o;
    }

    ENDCG

    SubShader
    {
        Tags{"Queue" = "Geometry+1"} 
        
        //render the outline
        Pass
        {
            //so we don't write to the depth buffer so that other things can be rendered on top
            ZWrite Off

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            //takes in the vertex as an argument
            half4 frag(v2f i) : COLOR
            {
                return _OutlineColor;
            }

            ENDCG
        }

        //then render the object on top as a normal surface shader render
        Pass
        {   
            ZWrite On
            
            //ShaderLab syntax
            Material
            {
                //the _Color here is the same _Color property declared at the top
                Diffuse[_Color]
                Ambient[_Color]
            }
                
            Lighting On
            
            //the _MainTex here is the same _MainTex property declared at the top
            SetTexture[_MainTex]
            {
                ConstantColor[_Color]
            }
            
            SetTexture[_MainTex]
            {
                Combine previous * primary DOUBLE
            }
            
        }
    }
}
