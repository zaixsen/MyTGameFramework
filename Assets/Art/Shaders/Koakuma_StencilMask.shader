// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/StencilMask"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		_StencilBuff_Reference("StencilBuff_Reference", Range( 0 , 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_StencilBuff_Comparison("StencilBuff_Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("Z Test", Float) = 8
		[Enum(Off,0,On,1)]_ZWrite("Z Write", Float) = 1
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBuff_PassFront("StencilBuff_PassFront", Float) = 2
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBuff_FailFront("StencilBuff_FailFront", Float) = 2
		[Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask("ColorMask", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
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
		ColorMask [_ColorMask]
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			half filler;
		};

		uniform half _StencilBuff_Reference;
		uniform half _StencilBuff_PassFront;
		uniform half _StencilBuff_FailFront;
		uniform half _ZTest;
		uniform half _StencilBuff_Comparison;
		uniform half _CullMode;
		uniform half _ColorMask;
		uniform half _ZWrite;
		uniform half4 _Color;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2560;12;2560;1407;903;375.5;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;16;607,356.5;Inherit;False;229;166;ColorMask;1;15;ColorMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;223,356.5;Inherit;False;368;167;Z Test and Write;2;13;12;Z Test and Write;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;223,162.5;Inherit;False;1044;169;StencilBuff;4;2;4;5;7;StencilBuff;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;3;227,-28.5;Inherit;False;225;166;CullMode;1;1;CullMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;273,212.5;Inherit;False;Property;_StencilBuff_Reference;StencilBuff_Reference;1;0;Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;795,214.5;Inherit;False;Property;_StencilBuff_PassFront;StencilBuff_PassFront;5;1;[Enum];Create;True;0;1;UnityEngine.Rendering.StencilOp;True;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;1024,215.5;Inherit;False;Property;_StencilBuff_FailFront;StencilBuff_FailFront;6;1;[Enum];Create;True;0;1;UnityEngine.Rendering.StencilOp;True;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;427,407.5;Inherit;False;Property;_ZTest;Z Test;3;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;553,213.5;Inherit;False;Property;_StencilBuff_Comparison;StencilBuff_Comparison;2;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;277,21.5;Inherit;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-344,-2.5;Inherit;False;Property;_Color;Color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;657,406.5;Inherit;False;Property;_ColorMask;ColorMask;7;1;[Enum];Create;True;0;1;UnityEngine.Rendering.ColorWriteMask;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;273,406.5;Inherit;False;Property;_ZWrite;Z Write;4;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/StencilMask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;13;0;True;12;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;100;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;True;15;True;0;True;2;255;False;-1;255;False;-1;0;True;4;0;True;5;0;True;7;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=D68F5A096696826F80E8C1E1A77268B7FF229D5A