// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/VFX_Refraction"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 3
		_RefractionMap("RefractionMap", 2D) = "white" {}
		_RefractionIntensity("RefractionIntensity", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha noshadow nofog 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform int _Z_Write;
		uniform int _Cull_Mode;
		uniform int _Z_Test;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _RefractionMap;
		SamplerState sampler_RefractionMap;
		uniform float4 _RefractionMap_ST;
		uniform half _RefractionIntensity;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_RefractionMap = i.uv_texcoord * _RefractionMap_ST.xy + _RefractionMap_ST.zw;
			half4 screenColor236 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,(( ase_grabScreenPosNorm + saturate( ( tex2D( _RefractionMap, uv_RefractionMap ).a * i.vertexColor.a * _RefractionIntensity ) ) )).xy);
			o.Emission = screenColor236.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2560;0;2560;1419;998.214;466.436;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-661.9222,125.1317;Inherit;False;0;234;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;234;-434.4086,104.5445;Inherit;True;Property;_RefractionMap;RefractionMap;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;83;-310.9692,297.4395;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;-384.214,465.564;Inherit;False;Property;_RefractionIntensity;RefractionIntensity;4;0;Create;True;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;-124.7344,172.1976;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;233;-188.1405,-83.244;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;278;14.78601,146.564;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;120.9555,-2.54228;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1;948.5275,28.2361;Inherit;False;225;166;Cull Mode;1;13;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;3;941.5273,246.2357;Inherit;False;356;166;Depth;2;14;12;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;237;279.9555,11.45781;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;236;501.9555,36.45781;Inherit;False;Global;_GrabScreen0;Grab Screen 0;52;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;12;991.5275,296.2359;Inherit;False;Property;_Z_Write;Z_Write;1;1;[Enum];Create;True;2;On;1;Off;0;0;True;0;False;1;1;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;13;998.5274,78.23592;Inherit;False;Property;_Cull_Mode;Cull_Mode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;14;1133.527,296.2359;Inherit;False;Property;_Z_Test;Z_Test;2;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;3;4;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;277;718.2001,24.7;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/VFX_Refraction;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Back;2;True;12;0;True;14;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;10;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;13;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;234;1;77;0
WireConnection;275;0;234;4
WireConnection;275;1;83;4
WireConnection;275;2;279;0
WireConnection;278;0;275;0
WireConnection;235;0;233;0
WireConnection;235;1;278;0
WireConnection;237;0;235;0
WireConnection;236;0;237;0
WireConnection;277;2;236;0
ASEEND*/
//CHKSM=6E86F1743268BD2FCFD84E892D89F765FC03F940