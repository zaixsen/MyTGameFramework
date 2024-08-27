// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/StencilTexture"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		_StencilBuff_Reference("StencilBuff_Reference", Range( 0 , 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("Z Test", Float) = 8
		[Enum(Off,0,On,1)]_ZWrite("Z Write", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_StencilBuff_Comparison("StencilBuff_Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBuff_PassFront("StencilBuff_PassFront", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBuff_FailFront("StencilBuff_FailFront", Float) = 0
		_Texture("Texture", 2D) = "white" {}
		_TextureColor("TextureColor", Color) = (1,1,1,0)
		[Toggle(_USE2NDUV_ON)] _Use2ndUV("Use2ndUV", Float) = 0
		_TextureAdd("TextureAdd", 2D) = "white" {}
		_TextureAddColor("TextureAddColor", Color) = (1,1,1,0)
		[Enum(Axis Y,0,Axis Z,1)]_AxisYorZ("Axis Y or Z", Float) = 0
		[Toggle(_AXISMINUS_ON)] _AxisMinus("AxisMinus", Float) = 0
		[HDR]_AddAxisColor("AddAxisColor", Color) = (0,0,0,0)
		_AxisPositionAdd("AxisPositionAdd", Float) = 0
		_AddAxisSmooth("AddAxisSmooth", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+100" }
		Cull [_CullMode]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Stencil
		{
			Ref [_StencilBuff_Reference]
			Comp [_StencilBuff_Comparison]
			Pass [_StencilBuff_PassFront]
			Fail [_StencilBuff_FailFront]
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _USE2NDUV_ON
		#pragma shader_feature_local _AXISMINUS_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldPos;
		};

		uniform half _ZWrite;
		uniform half _ZTest;
		uniform half _StencilBuff_PassFront;
		uniform half _CullMode;
		uniform half _StencilBuff_Reference;
		uniform half _StencilBuff_Comparison;
		uniform half _StencilBuff_FailFront;
		uniform half4 _TextureColor;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform half4 _TextureAddColor;
		uniform sampler2D _TextureAdd;
		uniform float4 _TextureAdd_ST;
		uniform half4 _AddAxisColor;
		uniform half _AddAxisSmooth;
		uniform half _AxisYorZ;
		uniform half _AxisPositionAdd;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			half4 temp_output_16_0 = ( _TextureColor * tex2D( _Texture, uv_Texture ) );
			float2 uv2_TextureAdd = i.uv2_texcoord2 * _TextureAdd_ST.xy + _TextureAdd_ST.zw;
			#ifdef _USE2NDUV_ON
				half4 staticSwitch20 = ( temp_output_16_0 + ( _TextureAddColor * tex2D( _TextureAdd, uv2_TextureAdd ) ) );
			#else
				half4 staticSwitch20 = temp_output_16_0;
			#endif
			float3 ase_worldPos = i.worldPos;
			half3 worldToObj25 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half lerpResult26 = lerp( worldToObj25.y , worldToObj25.z , _AxisYorZ);
			#ifdef _AXISMINUS_ON
				half staticSwitch38 = ( 1.0 - lerpResult26 );
			#else
				half staticSwitch38 = lerpResult26;
			#endif
			half smoothstepResult30 = smoothstep( 0.0 , _AddAxisSmooth , ( staticSwitch38 + _AxisPositionAdd ));
			half4 lerpResult35 = lerp( ( staticSwitch20 * _AddAxisColor ) , float4( 0,0,0,0 ) , smoothstepResult30);
			o.Albedo = ( staticSwitch20 + lerpResult35 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2560;12;2560;1407;490.0759;435.2441;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1763.208,545.0271;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1632.208,358.0268;Inherit;False;1;18;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1625.208,-26.97323;Inherit;False;0;15;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1525.208,732.0272;Inherit;False;Property;_AxisYorZ;Axis Y or Z;12;1;[Enum];Create;True;2;Axis Y;0;Axis Z;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;25;-1580.208,553.0272;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;15;-1384.208,-24.97323;Inherit;True;Property;_Texture;Texture;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-1303.208,-206.9732;Inherit;False;Property;_TextureColor;TextureColor;8;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1301.708,164.0268;Inherit;False;Property;_TextureAddColor;TextureAddColor;11;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;-1348.208,604.0272;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1389.208,353.0268;Inherit;True;Property;_TextureAdd;TextureAdd;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;39;-1252.208,725.0272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1052.208,-68.97324;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1052.708,294.0268;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-901.2076,179.0268;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1118.208,771.0272;Inherit;False;Property;_AxisPositionAdd;AxisPositionAdd;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;38;-1119.208,614.0272;Inherit;False;Property;_AxisMinus;AxisMinus;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-908.2076,654.0272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;20;-760.2077,-17.97323;Inherit;False;Property;_Use2ndUV;Use2ndUV;9;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1115.208,847.0272;Inherit;False;Property;_AddAxisSmooth;AddAxisSmooth;16;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-981.2076,433.0268;Inherit;False;Property;_AddAxisColor;AddAxisColor;14;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-753.2077,482.0268;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;30;-767.2077,641.0272;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;8;223,162.5;Inherit;False;1044;169;StencilBuff;4;2;4;5;7;StencilBuff;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;35;-610.2079,484.0268;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;14;223,356.5;Inherit;False;368;167;Z Test and Write;2;13;12;Z Test and Write;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;3;227,-28.5;Inherit;False;225;166;CullMode;1;1;CullMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.SurfaceDepthNode;40;-1631.426,1107.504;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;1024,215.5;Inherit;False;Property;_StencilBuff_FailFront;StencilBuff_FailFront;6;1;[Enum];Create;True;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-480.2084,-5.973235;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;553,213.5;Inherit;False;Property;_StencilBuff_Comparison;StencilBuff_Comparison;4;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;273,212.5;Inherit;False;Property;_StencilBuff_Reference;StencilBuff_Reference;1;0;Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;277,21.5;Inherit;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;795,214.5;Inherit;False;Property;_StencilBuff_PassFront;StencilBuff_PassFront;5;1;[Enum];Create;True;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;427,407.5;Inherit;False;Property;_ZTest;Z Test;2;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;273,406.5;Inherit;False;Property;_ZWrite;Z Write;3;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;-304.8561,1084.338;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;42;-1384.426,1115.504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;41;-1444.925,950.6044;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;43;-1306.426,1193.504;Inherit;False;Property;_OutlineViewDistance;OutlineViewDistance;18;0;Create;True;0;0;False;0;False;128;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;44;-1244.426,1035.504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;45;-1090.426,1120.504;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-989.426,958.5045;Inherit;False;Constant;_Float2;Float 2;64;0;Create;True;0;0;False;0;False;0.0015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1102.426,1044.504;Inherit;False;Property;_OutlineMaxDistanceWidth;OutlineMaxDistanceWidth;19;0;Create;True;0;0;False;0;False;0.15;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-984.426,1222.504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-755.7261,1128.103;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;51;-797.8541,941.3378;Inherit;False;Property;_OutlineColor;OutlineColor;17;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OutlineNode;52;-541.5662,1080.982;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/StencilTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;13;0;True;12;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;100;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;0;True;2;255;False;-1;255;False;-1;0;True;4;0;True;5;0;True;7;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;24;0
WireConnection;15;1;17;0
WireConnection;26;0;25;2
WireConnection;26;1;25;3
WireConnection;26;2;27;0
WireConnection;18;1;19;0
WireConnection;39;0;26;0
WireConnection;16;0;11;0
WireConnection;16;1;15;0
WireConnection;22;0;21;0
WireConnection;22;1;18;0
WireConnection;23;0;16;0
WireConnection;23;1;22;0
WireConnection;38;1;26;0
WireConnection;38;0;39;0
WireConnection;28;0;38;0
WireConnection;28;1;29;0
WireConnection;20;1;16;0
WireConnection;20;0;23;0
WireConnection;33;0;20;0
WireConnection;33;1;34;0
WireConnection;30;0;28;0
WireConnection;30;2;31;0
WireConnection;35;0;33;0
WireConnection;35;2;30;0
WireConnection;32;0;20;0
WireConnection;32;1;35;0
WireConnection;53;0;52;0
WireConnection;42;0;40;0
WireConnection;44;0;41;0
WireConnection;44;1;42;0
WireConnection;45;0;44;0
WireConnection;45;1;43;0
WireConnection;47;0;45;0
WireConnection;49;0;48;0
WireConnection;49;1;46;0
WireConnection;49;2;47;0
WireConnection;52;0;51;0
WireConnection;52;1;49;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=5968593049D749F76F497C16491209D4C8332078