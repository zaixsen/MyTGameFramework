// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/VFX_CylinderLight"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Src("Blend_Src", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Dst("Blend_Dst", Int) = 10
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 4
		_HDR("HDR", Range( 0 , 50)) = 1
		_DepthFadeDistance("DepthFadeDistance", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite [_Z_Write]
		ZTest [_Z_Test]
		Blend [_Blend_Src] [_Blend_Dst]
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow nofog 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			half3 worldNormal;
			float3 uv_texcoord;
			float4 screenPos;
		};

		uniform int _Blend_Src;
		uniform int _Cull_Mode;
		uniform int _Z_Write;
		uniform int _Blend_Dst;
		uniform int _Z_Test;
		uniform half _HDR;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthFadeDistance;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( i.vertexColor * _HDR ).rgb;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = i.worldNormal;
			half fresnelNdotV321 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode321 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV321, (0.0 + (i.uv_texcoord.z - 0.0) * (15.0 - 0.0) / (1.0 - 0.0)) ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth169 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth169 = saturate( abs( ( screenDepth169 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
			o.Alpha = ( i.vertexColor.a * saturate( fresnelNode321 ) * distanceDepth169 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
7;6;2546;1373;1027.176;611.0526;1;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;276;-455.8837,29.43613;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;78;-236.509,20.51039;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;321;-42.07214,32.60645;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-93.5639,248.1515;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;943.5275,-109.7639;Inherit;False;225;166;Cull Mode;1;13;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;320;250.25,135.5375;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;272;239.8362,-243.8578;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;169;145.4362,235.1515;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;943.5273,89.23524;Inherit;False;372;143;BlendMode;2;8;6;BlendMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;282;209.6549,37.0385;Inherit;False;Property;_HDR;HDR;6;0;Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;943.5273,266.2357;Inherit;False;356;166;Depth;2;14;12;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;14;1135.527,316.2359;Inherit;False;Property;_Z_Test;Z_Test;5;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;539.8111,21.5266;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;6;993.5275,140.2354;Inherit;False;Property;_Blend_Src;Blend_Src;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;3;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;474.4677,217.907;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;13;993.5274,-59.76408;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;12;993.5275,316.2359;Inherit;False;Property;_Z_Write;Z_Write;4;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;8;1137.527,139.2354;Inherit;False;Property;_Blend_Dst;Blend_Dst;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;1;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;718.2001,24.7;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/VFX_CylinderLight;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;12;0;True;14;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;1;5;True;6;10;True;8;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;13;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;78;0;276;3
WireConnection;321;3;78;0
WireConnection;320;0;321;0
WireConnection;169;0;170;0
WireConnection;156;0;272;0
WireConnection;156;1;282;0
WireConnection;300;0;272;4
WireConnection;300;1;320;0
WireConnection;300;2;169;0
WireConnection;0;2;156;0
WireConnection;0;9;300;0
ASEEND*/
//CHKSM=1A1E157A28FD42C7D8DE80806098D9C2E053F844