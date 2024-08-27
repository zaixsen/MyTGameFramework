// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/ScreenRadius"
{
	Properties
	{
		[Toggle(_USE16XPROCESS_ON)] _Use16Xprocess("Use16Xprocess", Float) = 0
		[Enum(RadiusBlur,0,WBflash,1)]_ScreenEffectStyle("ScreenEffectStyle", Float) = 0
		[Enum(Off,0,On,1)]_VertexAlphaControl("VertexAlphaControl", Float) = 1
		_RadiusDistance("RadiusDistance", Float) = 0.01
		_RadiusIntensity("RadiusIntensity", Float) = 0
		_WB_Color1("WB_Color1", Color) = (0,0,0,0)
		_WB_Color2("WB_Color2", Color) = (1,1,1,0)
		_WB_Radius("WB_Radius", Range( 0 , 1)) = 0
		_WB_Softness("WB_Softness", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+1000" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _USE16XPROCESS_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform half _RadiusDistance;
		uniform half _RadiusIntensity;
		uniform half _VertexAlphaControl;
		uniform half _WB_Radius;
		uniform half _WB_Softness;
		uniform half4 _WB_Color1;
		uniform half4 _WB_Color2;
		uniform half _ScreenEffectStyle;


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
			half4 temp_cast_0 = (0.5).xxxx;
			half lerpResult47 = lerp( _RadiusIntensity , i.vertexColor.a , _VertexAlphaControl);
			half4 temp_output_4_0 = ( ( ase_grabScreenPosNorm - temp_cast_0 ) * _RadiusDistance * lerpResult47 );
			half4 temp_output_6_0 = ( ase_grabScreenPosNorm - temp_output_4_0 );
			half4 screenColor7 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_6_0.xy);
			half4 temp_cast_2 = (0.5).xxxx;
			half4 temp_cast_3 = (0.5).xxxx;
			half4 temp_output_9_0 = ( temp_output_6_0 - temp_output_4_0 );
			half4 screenColor23 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_9_0.xy);
			half4 temp_cast_5 = (0.5).xxxx;
			half4 temp_cast_6 = (0.5).xxxx;
			half4 temp_cast_7 = (0.5).xxxx;
			half4 temp_output_16_0 = ( temp_output_9_0 - temp_output_4_0 );
			half4 screenColor10 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_16_0.xy);
			half4 temp_cast_9 = (0.5).xxxx;
			half4 temp_cast_10 = (0.5).xxxx;
			half4 temp_cast_11 = (0.5).xxxx;
			half4 temp_cast_12 = (0.5).xxxx;
			half4 temp_output_17_0 = ( temp_output_16_0 - temp_output_4_0 );
			half4 screenColor11 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_17_0.xy);
			half4 temp_cast_14 = (0.5).xxxx;
			half4 temp_cast_15 = (0.5).xxxx;
			half4 temp_cast_16 = (0.5).xxxx;
			half4 temp_cast_17 = (0.5).xxxx;
			half4 temp_cast_18 = (0.5).xxxx;
			half4 temp_output_18_0 = ( temp_output_17_0 - temp_output_4_0 );
			half4 screenColor12 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_18_0.xy);
			half4 temp_cast_20 = (0.5).xxxx;
			half4 temp_cast_21 = (0.5).xxxx;
			half4 temp_cast_22 = (0.5).xxxx;
			half4 temp_cast_23 = (0.5).xxxx;
			half4 temp_cast_24 = (0.5).xxxx;
			half4 temp_cast_25 = (0.5).xxxx;
			half4 temp_output_19_0 = ( temp_output_18_0 - temp_output_4_0 );
			half4 screenColor13 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_19_0.xy);
			half4 temp_cast_27 = (0.5).xxxx;
			half4 temp_cast_28 = (0.5).xxxx;
			half4 temp_cast_29 = (0.5).xxxx;
			half4 temp_cast_30 = (0.5).xxxx;
			half4 temp_cast_31 = (0.5).xxxx;
			half4 temp_cast_32 = (0.5).xxxx;
			half4 temp_cast_33 = (0.5).xxxx;
			half4 temp_output_20_0 = ( temp_output_19_0 - temp_output_4_0 );
			half4 screenColor14 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_20_0.xy);
			half4 temp_cast_35 = (0.5).xxxx;
			half4 temp_cast_36 = (0.5).xxxx;
			half4 temp_cast_37 = (0.5).xxxx;
			half4 temp_cast_38 = (0.5).xxxx;
			half4 temp_cast_39 = (0.5).xxxx;
			half4 temp_cast_40 = (0.5).xxxx;
			half4 temp_cast_41 = (0.5).xxxx;
			half4 temp_cast_42 = (0.5).xxxx;
			half4 temp_output_21_0 = ( temp_output_20_0 - temp_output_4_0 );
			half4 screenColor15 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_21_0.xy);
			half4 temp_output_44_0 = ( screenColor7 + screenColor23 + screenColor10 + screenColor11 + screenColor12 + screenColor13 + screenColor14 + screenColor15 );
			half4 temp_cast_44 = (0.5).xxxx;
			half4 temp_cast_45 = (0.5).xxxx;
			half4 temp_cast_46 = (0.5).xxxx;
			half4 temp_cast_47 = (0.5).xxxx;
			half4 temp_cast_48 = (0.5).xxxx;
			half4 temp_cast_49 = (0.5).xxxx;
			half4 temp_cast_50 = (0.5).xxxx;
			half4 temp_cast_51 = (0.5).xxxx;
			half4 temp_cast_52 = (0.5).xxxx;
			half4 temp_output_35_0 = ( temp_output_21_0 - temp_output_4_0 );
			half4 screenColor42 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_35_0.xy);
			half4 temp_cast_54 = (0.5).xxxx;
			half4 temp_cast_55 = (0.5).xxxx;
			half4 temp_cast_56 = (0.5).xxxx;
			half4 temp_cast_57 = (0.5).xxxx;
			half4 temp_cast_58 = (0.5).xxxx;
			half4 temp_cast_59 = (0.5).xxxx;
			half4 temp_cast_60 = (0.5).xxxx;
			half4 temp_cast_61 = (0.5).xxxx;
			half4 temp_cast_62 = (0.5).xxxx;
			half4 temp_cast_63 = (0.5).xxxx;
			half4 temp_output_34_0 = ( temp_output_35_0 - temp_output_4_0 );
			half4 screenColor33 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_34_0.xy);
			half4 temp_cast_65 = (0.5).xxxx;
			half4 temp_cast_66 = (0.5).xxxx;
			half4 temp_cast_67 = (0.5).xxxx;
			half4 temp_cast_68 = (0.5).xxxx;
			half4 temp_cast_69 = (0.5).xxxx;
			half4 temp_cast_70 = (0.5).xxxx;
			half4 temp_cast_71 = (0.5).xxxx;
			half4 temp_cast_72 = (0.5).xxxx;
			half4 temp_cast_73 = (0.5).xxxx;
			half4 temp_cast_74 = (0.5).xxxx;
			half4 temp_cast_75 = (0.5).xxxx;
			half4 temp_output_36_0 = ( temp_output_34_0 - temp_output_4_0 );
			half4 screenColor31 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_36_0.xy);
			half4 temp_cast_77 = (0.5).xxxx;
			half4 temp_cast_78 = (0.5).xxxx;
			half4 temp_cast_79 = (0.5).xxxx;
			half4 temp_cast_80 = (0.5).xxxx;
			half4 temp_cast_81 = (0.5).xxxx;
			half4 temp_cast_82 = (0.5).xxxx;
			half4 temp_cast_83 = (0.5).xxxx;
			half4 temp_cast_84 = (0.5).xxxx;
			half4 temp_cast_85 = (0.5).xxxx;
			half4 temp_cast_86 = (0.5).xxxx;
			half4 temp_cast_87 = (0.5).xxxx;
			half4 temp_cast_88 = (0.5).xxxx;
			half4 temp_output_37_0 = ( temp_output_36_0 - temp_output_4_0 );
			half4 screenColor26 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_37_0.xy);
			half4 temp_cast_90 = (0.5).xxxx;
			half4 temp_cast_91 = (0.5).xxxx;
			half4 temp_cast_92 = (0.5).xxxx;
			half4 temp_cast_93 = (0.5).xxxx;
			half4 temp_cast_94 = (0.5).xxxx;
			half4 temp_cast_95 = (0.5).xxxx;
			half4 temp_cast_96 = (0.5).xxxx;
			half4 temp_cast_97 = (0.5).xxxx;
			half4 temp_cast_98 = (0.5).xxxx;
			half4 temp_cast_99 = (0.5).xxxx;
			half4 temp_cast_100 = (0.5).xxxx;
			half4 temp_cast_101 = (0.5).xxxx;
			half4 temp_cast_102 = (0.5).xxxx;
			half4 temp_output_38_0 = ( temp_output_37_0 - temp_output_4_0 );
			half4 screenColor27 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_38_0.xy);
			half4 temp_cast_104 = (0.5).xxxx;
			half4 temp_cast_105 = (0.5).xxxx;
			half4 temp_cast_106 = (0.5).xxxx;
			half4 temp_cast_107 = (0.5).xxxx;
			half4 temp_cast_108 = (0.5).xxxx;
			half4 temp_cast_109 = (0.5).xxxx;
			half4 temp_cast_110 = (0.5).xxxx;
			half4 temp_cast_111 = (0.5).xxxx;
			half4 temp_cast_112 = (0.5).xxxx;
			half4 temp_cast_113 = (0.5).xxxx;
			half4 temp_cast_114 = (0.5).xxxx;
			half4 temp_cast_115 = (0.5).xxxx;
			half4 temp_cast_116 = (0.5).xxxx;
			half4 temp_cast_117 = (0.5).xxxx;
			half4 temp_output_39_0 = ( temp_output_38_0 - temp_output_4_0 );
			half4 screenColor28 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_39_0.xy);
			half4 temp_cast_119 = (0.5).xxxx;
			half4 temp_cast_120 = (0.5).xxxx;
			half4 temp_cast_121 = (0.5).xxxx;
			half4 temp_cast_122 = (0.5).xxxx;
			half4 temp_cast_123 = (0.5).xxxx;
			half4 temp_cast_124 = (0.5).xxxx;
			half4 temp_cast_125 = (0.5).xxxx;
			half4 temp_cast_126 = (0.5).xxxx;
			half4 temp_cast_127 = (0.5).xxxx;
			half4 temp_cast_128 = (0.5).xxxx;
			half4 temp_cast_129 = (0.5).xxxx;
			half4 temp_cast_130 = (0.5).xxxx;
			half4 temp_cast_131 = (0.5).xxxx;
			half4 temp_cast_132 = (0.5).xxxx;
			half4 temp_cast_133 = (0.5).xxxx;
			half4 temp_output_40_0 = ( temp_output_39_0 - temp_output_4_0 );
			half4 screenColor29 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_40_0.xy);
			half4 temp_cast_135 = (0.5).xxxx;
			half4 temp_cast_136 = (0.5).xxxx;
			half4 temp_cast_137 = (0.5).xxxx;
			half4 temp_cast_138 = (0.5).xxxx;
			half4 temp_cast_139 = (0.5).xxxx;
			half4 temp_cast_140 = (0.5).xxxx;
			half4 temp_cast_141 = (0.5).xxxx;
			half4 temp_cast_142 = (0.5).xxxx;
			half4 temp_cast_143 = (0.5).xxxx;
			half4 temp_cast_144 = (0.5).xxxx;
			half4 temp_cast_145 = (0.5).xxxx;
			half4 temp_cast_146 = (0.5).xxxx;
			half4 temp_cast_147 = (0.5).xxxx;
			half4 temp_cast_148 = (0.5).xxxx;
			half4 temp_cast_149 = (0.5).xxxx;
			half4 temp_cast_150 = (0.5).xxxx;
			half4 screenColor30 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_40_0 - temp_output_4_0 ).xy);
			#ifdef _USE16XPROCESS_ON
				half4 staticSwitch53 = ( ( temp_output_44_0 + ( screenColor42 + screenColor33 + screenColor31 + screenColor26 + screenColor27 + screenColor28 + screenColor29 + screenColor30 ) ) / 16.0 );
			#else
				half4 staticSwitch53 = ( temp_output_44_0 / 8.0 );
			#endif
			half lerpResult73 = lerp( _WB_Softness , i.vertexColor.a , _VertexAlphaControl);
			half4 temp_cast_152 = (( _WB_Radius + lerpResult73 )).xxxx;
			half4 temp_cast_153 = (( _WB_Radius - lerpResult73 )).xxxx;
			half4 lerpResult65 = lerp( _WB_Color1 , _WB_Color2 , (staticSwitch53).r);
			half4 smoothstepResult68 = smoothstep( temp_cast_152 , temp_cast_153 , lerpResult65);
			half4 lerpResult69 = lerp( staticSwitch53 , saturate( smoothstepResult68 ) , _ScreenEffectStyle);
			o.Emission = ( i.vertexColor * lerpResult69 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2560;12;2560;1407;1578.417;390.3471;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;60;-1800.23,311.2855;Inherit;False;Property;_RadiusIntensity;RadiusIntensity;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;1;-1829,-139.5;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-1801.23,391.2855;Inherit;False;Property;_VertexAlphaControl;VertexAlphaControl;3;1;[Enum];Create;True;2;Off;0;On;1;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1785,43.5;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;46;-1803.507,146.9141;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1620,47.5;Inherit;False;Property;_RadiusDistance;RadiusDistance;4;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-1577.206,240.114;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-1588,-52.5;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1192.212,-1346.139;Inherit;False;486.9999;1591.9;8X;16;11;12;15;10;14;7;23;13;21;20;19;18;17;16;9;6;8X;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1431,-29.5;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-1140.912,-1296.14;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-1142.212,-1096.44;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1137.213,-887.2407;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-1128.513,-686.3403;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-1118.813,-494.4398;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1113.213,-312.4399;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1121.713,-123.4397;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1202.391,304.3588;Inherit;False;490.7;1586.7;16X;16;33;28;31;30;27;29;26;42;41;40;39;38;37;36;34;35;16X;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-1125.013,64.56001;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-1151.091,354.3589;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-1152.391,554.0585;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-1147.391,763.2591;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-1138.691,964.1591;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-1128.991,1156.059;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-1123.391,1338.058;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-1131.891,1527.058;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-1135.191,1715.057;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;33;-952.7894,538.7809;Inherit;False;Global;_GrabScreen15;Grab Screen 15;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;10;-944.1135,-931.4407;Inherit;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;12;-938.1135,-554.4399;Inherit;False;Global;_GrabScreen4;Grab Screen 4;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;42;-950.789,346.9322;Inherit;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;11;-941.1135,-744.4405;Inherit;False;Global;_GrabScreen3;Grab Screen 3;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;15;-931.1135,28.55991;Inherit;False;Global;_GrabScreen7;Grab Screen 7;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;31;-954.2912,719.0587;Inherit;False;Global;_GrabScreen14;Grab Screen 14;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;30;-941.2913,1679.057;Inherit;False;Global;_GrabScreen13;Grab Screen 13;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;26;-951.2913,906.0604;Inherit;False;Global;_GrabScreen9;Grab Screen 9;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;13;-935.1135,-358.44;Inherit;False;Global;_GrabScreen5;Grab Screen 5;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;28;-945.2913,1292.058;Inherit;False;Global;_GrabScreen11;Grab Screen 11;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;7;-947.1135,-1289.44;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;14;-932.1135,-168.4399;Inherit;False;Global;_GrabScreen6;Grab Screen 6;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;27;-948.2913,1096.059;Inherit;False;Global;_GrabScreen10;Grab Screen 10;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;29;-942.2913,1482.058;Inherit;False;Global;_GrabScreen12;Grab Screen 12;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;23;-942.612,-1111.718;Inherit;False;Global;_GrabScreen8;Grab Screen 8;1;0;Create;True;0;0;False;0;False;Instance;7;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-680.3354,-12.66022;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-684.1907,306.3543;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-541.5068,98.91406;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-544.0068,371.4141;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-545.5068,210.9141;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-404.5068,-10.08594;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-402.0068,281.4141;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;53;-256.0069,87.71406;Inherit;False;Property;_Use16Xprocess;Use16Xprocess;1;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-626.3766,654.3906;Inherit;False;Property;_WB_Softness;WB_Softness;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;76;-7.074219,216.1959;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;73;-271.5126,807.4812;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-637.8046,543.9628;Inherit;False;Property;_WB_Radius;WB_Radius;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-257.9937,413.239;Inherit;False;Property;_WB_Color2;WB_Color2;7;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;71;-257.0925,223.8187;Inherit;False;Property;_WB_Color1;WB_Color1;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;65;-24.01248,312.4526;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;29.83373,611.5652;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-7.123008,477.8842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;175.2511,312.9055;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;332.8716,362.0413;Inherit;False;Property;_ScreenEffectStyle;ScreenEffectStyle;2;1;[Enum];Create;True;2;RadiusBlur;0;WBflash;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;330.8378,228.2287;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;494.5668,154.2021;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;685.1627,16.13354;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;925.4999,28.3;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/ScreenRadius;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;1000;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;60;0
WireConnection;47;1;46;4
WireConnection;47;2;58;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;4;0;2;0
WireConnection;4;1;5;0
WireConnection;4;2;47;0
WireConnection;6;0;1;0
WireConnection;6;1;4;0
WireConnection;9;0;6;0
WireConnection;9;1;4;0
WireConnection;16;0;9;0
WireConnection;16;1;4;0
WireConnection;17;0;16;0
WireConnection;17;1;4;0
WireConnection;18;0;17;0
WireConnection;18;1;4;0
WireConnection;19;0;18;0
WireConnection;19;1;4;0
WireConnection;20;0;19;0
WireConnection;20;1;4;0
WireConnection;21;0;20;0
WireConnection;21;1;4;0
WireConnection;35;0;21;0
WireConnection;35;1;4;0
WireConnection;34;0;35;0
WireConnection;34;1;4;0
WireConnection;36;0;34;0
WireConnection;36;1;4;0
WireConnection;37;0;36;0
WireConnection;37;1;4;0
WireConnection;38;0;37;0
WireConnection;38;1;4;0
WireConnection;39;0;38;0
WireConnection;39;1;4;0
WireConnection;40;0;39;0
WireConnection;40;1;4;0
WireConnection;41;0;40;0
WireConnection;41;1;4;0
WireConnection;33;0;34;0
WireConnection;10;0;16;0
WireConnection;12;0;18;0
WireConnection;42;0;35;0
WireConnection;11;0;17;0
WireConnection;15;0;21;0
WireConnection;31;0;36;0
WireConnection;30;0;41;0
WireConnection;26;0;37;0
WireConnection;13;0;19;0
WireConnection;28;0;39;0
WireConnection;7;0;6;0
WireConnection;14;0;20;0
WireConnection;27;0;38;0
WireConnection;29;0;40;0
WireConnection;23;0;9;0
WireConnection;44;0;7;0
WireConnection;44;1;23;0
WireConnection;44;2;10;0
WireConnection;44;3;11;0
WireConnection;44;4;12;0
WireConnection;44;5;13;0
WireConnection;44;6;14;0
WireConnection;44;7;15;0
WireConnection;45;0;42;0
WireConnection;45;1;33;0
WireConnection;45;2;31;0
WireConnection;45;3;26;0
WireConnection;45;4;27;0
WireConnection;45;5;28;0
WireConnection;45;6;29;0
WireConnection;45;7;30;0
WireConnection;52;0;44;0
WireConnection;52;1;45;0
WireConnection;48;0;44;0
WireConnection;48;1;49;0
WireConnection;51;0;52;0
WireConnection;51;1;50;0
WireConnection;53;1;48;0
WireConnection;53;0;51;0
WireConnection;76;0;53;0
WireConnection;73;0;64;0
WireConnection;73;1;46;4
WireConnection;73;2;58;0
WireConnection;65;0;71;0
WireConnection;65;1;72;0
WireConnection;65;2;76;0
WireConnection;67;0;63;0
WireConnection;67;1;73;0
WireConnection;66;0;63;0
WireConnection;66;1;73;0
WireConnection;68;0;65;0
WireConnection;68;1;66;0
WireConnection;68;2;67;0
WireConnection;75;0;68;0
WireConnection;69;0;53;0
WireConnection;69;1;75;0
WireConnection;69;2;70;0
WireConnection;56;0;46;0
WireConnection;56;1;69;0
WireConnection;0;2;56;0
ASEEND*/
//CHKSM=9A182F839D5C3E878C258DA4AEE41CC91B9F3271