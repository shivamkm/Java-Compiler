import ply.yacc as yacc
import lexer, sys
from lexer import tokens
import ply.lex as lex

def p_0(p):
  'TypeName : IDENTIFIER '

def p_1(p):
  'TypeName : temporary0 IDENTIFIER '

def p_2(p):
  'Type : PrimitiveType '

def p_3(p):
  'Type : ReferenceType '

def p_4(p):
  'PrimitiveType : NumericType '

def p_5(p):
  'PrimitiveType : BOOLEAN '

def p_6(p):
  'NumericType : BYTE '

def p_7(p):
  'NumericType : SHORT '

def p_8(p):
  'NumericType : INT '

def p_9(p):
  'NumericType : LONG '

def p_10(p):
  'NumericType : CHAR '

def p_11(p):
  'NumericType : FLOAT '

def p_12(p):
  'NumericType : DOUBLE '

def p_13(p):
  'ReferenceType : ClassType '

def p_14(p):
  'ReferenceType : ArrayType '

def p_15(p):
  'temporary0 : temporary0 IDENTIFIER DOT '

def p_16(p):
  'temporary0 : IDENTIFIER DOT '

def p_17(p):
  'ClassType : IDENTIFIER '

def p_18(p):
  'ClassType : temporary0 IDENTIFIER '

def p_19(p):
  'PostFixType : IDENTIFIER '

def p_20(p):
  'PostFixType : temporary0 IDENTIFIER '

def p_21(p):
  'ArrayType : PrimitiveType Dims '

def p_22(p):
  'ArrayType : ClassType Dims '

def p_23(p):
  'Dims : LEFT_SQUARE RIGHT_SQUARE '

def p_24(p):
  'Dims : Dims LEFT_SQUARE RIGHT_SQUARE '

def p_25(p):
  'TypeParameter : IDENTIFIER '

def p_26(p):
  'TypeParameter : IDENTIFIER TypeBound '

def p_27(p):
  'TypeBound : EXTENDS IDENTIFIER '

def p_28(p):
  'TypeBound : EXTENDS ClassType AdditionalBound '

def p_29(p):
  'AdditionalBound : LAND ClassType '

def p_30(p):
  'AdditionalBound : AdditionalBound LAND ClassType '

def p_31(p):
  'CompilationUnit : PackageDeclaration ImportDeclaration TypeDeclaration '

def p_32(p):
  'CompilationUnit : PackageDeclaration ImportDeclaration '

def p_33(p):
  'CompilationUnit : PackageDeclaration TypeDeclaration '

def p_34(p):
  'CompilationUnit : PackageDeclaration '

def p_35(p):
  'CompilationUnit : ImportDeclaration '

def p_36(p):
  'CompilationUnit : TypeDeclaration '

def p_37(p):
  'CompilationUnit : ImportDeclaration TypeDeclaration '

def p_38(p):
  'PackageDeclaration : PACKAGE TypeName SEMI_COLON '

def p_39(p):
  'ImportDeclaration : IMPORT TypeName SEMI_COLON '

def p_40(p):
  'ImportDeclaration : IMPORT temporary0 MUL SEMI_COLON '

def p_41(p):
  'ImportDeclaration : IMPORT STATIC temporary0 IDENTIFIER SEMI_COLON '

def p_42(p):
  'ImportDeclaration : IMPORT STATIC temporary0 MUL SEMI_COLON '

def p_43(p):
  'ImportDeclaration : ImportDeclaration IMPORT TypeName SEMI_COLON '

def p_44(p):
  'ImportDeclaration : ImportDeclaration IMPORT temporary0 MUL SEMI_COLON '

def p_45(p):
  'ImportDeclaration : ImportDeclaration IMPORT STATIC temporary0 IDENTIFIER SEMI_COLON '

def p_46(p):
  'ImportDeclaration : ImportDeclaration IMPORT STATIC temporary0 MUL SEMI_COLON '

def p_47(p):
  'TypeDeclaration : ClassDeclaration '

def p_48(p):
  'TypeDeclaration : InterfaceDeclaration '

def p_49(p):
  'TypeDeclaration : SEMI_COLON '

def p_50(p):
  'TypeDeclaration : TypeDeclaration ClassDeclaration '

def p_51(p):
  'TypeDeclaration : TypeDeclaration InterfaceDeclaration '

def p_52(p):
  'TypeDeclaration : TypeDeclaration SEMI_COLON '

def p_53(p):
  'ClassDeclaration : NormalClassDeclaration '

def p_54(p):
  'ClassDeclaration : EnumDeclaration '

def p_55(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters SuperClass Superinterfaces ClassBody '

def p_56(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters SuperClass ClassBody '

def p_57(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters Superinterfaces ClassBody '

def p_58(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER SuperClass Superinterfaces ClassBody '

def p_59(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters ClassBody '

def p_60(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER SuperClass ClassBody '

def p_61(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER Superinterfaces ClassBody '

def p_62(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER ClassBody '

def p_63(p):
  'ClassModifier : PUBLIC ClassModifier '

def p_64(p):
  'ClassModifier : PROTECTED ClassModifier '

def p_65(p):
  'ClassModifier : PRIVATE ClassModifier '

def p_66(p):
  'ClassModifier : ABSTRACT ClassModifier '

def p_67(p):
  'ClassModifier : STATIC ClassModifier '

def p_68(p):
  'ClassModifier : FINAL ClassModifier '

def p_69(p):
  'ClassModifier : STRICTFP ClassModifier '

def p_70(p):
  'ClassModifier : CLASS '

def p_71(p):
  'TypeParameters : LT TypeParameterList GT '

def p_72(p):
  'TypeParameterList : TypeParameterList COMMA TypeParameter '

def p_73(p):
  'TypeParameterList : TypeParameter '

def p_74(p):
  'SuperClass : EXTENDS ClassType '

def p_75(p):
  'Superinterfaces : IMPLEMENTS InterfaceTypeList '

def p_76(p):
  'InterfaceTypeList : InterfaceTypeList COMMA ClassType '

def p_77(p):
  'InterfaceTypeList : ClassType '

def p_78(p):
  'ClassBody : LEFT_CURLY ClassBodyDeclaration RIGHT_CURLY '

def p_79(p):
  'ClassBody : LEFT_CURLY RIGHT_CURLY '

def p_80(p):
  'ClassBodyDeclaration : ClassMemberDeclaration '

def p_81(p):
  'ClassBodyDeclaration : Block '

def p_82(p):
  'ClassBodyDeclaration : STATIC Block '

def p_83(p):
  'ClassBodyDeclaration : ConstructorDeclaration '

def p_84(p):
  'ClassBodyDeclaration : ClassBodyDeclaration ClassMemberDeclaration '

def p_85(p):
  'ClassBodyDeclaration : ClassBodyDeclaration Block '

def p_86(p):
  'ClassBodyDeclaration : ClassBodyDeclaration STATIC Block '

def p_87(p):
  'ClassBodyDeclaration : ClassBodyDeclaration ConstructorDeclaration '

def p_88(p):
  'ClassMemberDeclaration : FieldDeclaration '

def p_89(p):
  'ClassMemberDeclaration : MethodDeclaration '

def p_90(p):
  'ClassMemberDeclaration : ClassDeclaration '

def p_91(p):
  'ClassMemberDeclaration : InterfaceDeclaration '

def p_92(p):
  'ClassMemberDeclaration : SEMI_COLON '

def p_93(p):
  'FieldDeclaration : FieldModifier SEMI_COLON '

def p_94(p):
  'FieldModifier : PUBLIC FieldModifier '

def p_95(p):
  'FieldModifier : PROTECTED FieldModifier '

def p_96(p):
  'FieldModifier : PRIVATE FieldModifier '

def p_97(p):
  'FieldModifier : STATIC FieldModifier '

def p_98(p):
  'FieldModifier : FINAL FieldModifier '

def p_99(p):
  'FieldModifier : TRANSIENT FieldModifier '

def p_100(p):
  'FieldModifier : VOLATILE FieldModifier '

def p_101(p):
  'FieldModifier : Type VariableDeclaratorList '

def p_102(p):
  'VariableDeclaratorList : VariableDeclaratorList COMMA VariableDeclarator '

def p_103(p):
  'VariableDeclaratorList : VariableDeclarator '

def p_104(p):
  'VariableDeclarator : VariableDeclaratorId '

def p_105(p):
  'VariableDeclarator : VariableDeclaratorId ASSIGN VariableInitializer '

def p_106(p):
  'VariableDeclaratorId : IDENTIFIER '

def p_107(p):
  'VariableDeclaratorId : IDENTIFIER Dims '

def p_108(p):
  'VariableInitializer : Expression '

def p_109(p):
  'VariableInitializer : ArrayInitializer '

def p_110(p):
  'MethodDeclaration : InterfaceMethodDeclaration '

def p_111(p):
  'MethodDeclaration : FINAL InterfaceMethodDeclaration '

def p_112(p):
  'MethodHeader : Type MethodDeclarator '

def p_113(p):
  'MethodHeader : Type MethodDeclarator Throws '

def p_114(p):
  'MethodHeader : TypeParameters Type MethodDeclarator '

def p_115(p):
  'MethodHeader : TypeParameters Type MethodDeclarator Throws '

def p_116(p):
  'MethodHeader : VOID MethodDeclarator '

def p_117(p):
  'MethodHeader : VOID MethodDeclarator Throws '

def p_118(p):
  'MethodHeader : TypeParameters VOID MethodDeclarator '

def p_119(p):
  'MethodHeader : TypeParameters VOID MethodDeclarator Throws '

def p_120(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN Dims '

def p_121(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN Dims '

def p_122(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '

def p_123(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_124(p):
  'FormalParameterList : ReceiverParameter '

def p_125(p):
  'FormalParameterList : FormalParameters COMMA LastFormalParameter '

def p_126(p):
  'FormalParameterList : LastFormalParameter '

def p_127(p):
  'FormalParameters : FormalParameters COMMA FormalParameter '

def p_128(p):
  'FormalParameters : FormalParameter '

def p_129(p):
  'FormalParameters : ReceiverParameter '

def p_130(p):
  'FormalParameter : FINAL Type VariableDeclaratorId '

def p_131(p):
  'FormalParameter : Type VariableDeclaratorId '

def p_132(p):
  'LastFormalParameter : FINAL Type TRIPLE_DOT VariableDeclaratorId '

def p_133(p):
  'LastFormalParameter : Type TRIPLE_DOT VariableDeclaratorId '

def p_134(p):
  'LastFormalParameter : FormalParameter '

def p_135(p):
  'ReceiverParameter : Type THIS '

def p_136(p):
  'ReceiverParameter : Type IDENTIFIER DOT THIS '

def p_137(p):
  'Throws : THROWS ExceptionTypeList '

def p_138(p):
  'ExceptionTypeList : ExceptionTypeList COMMA ClassType '

def p_139(p):
  'ExceptionTypeList : ClassType '

def p_140(p):
  'MethodBody : Block '

def p_141(p):
  'MethodBody : SEMI_COLON '

def p_142(p):
  'ConstructorDeclaration : ConstructorModifier Throws ConstructorBody '

def p_143(p):
  'ConstructorDeclaration : ConstructorModifier ConstructorBody '

def p_144(p):
  'ConstructorModifier : PUBLIC ConstructorModifier '

def p_145(p):
  'ConstructorModifier : PROTECTED ConstructorModifier '

def p_146(p):
  'ConstructorModifier : PRIVATE ConstructorModifier '

def p_147(p):
  'ConstructorModifier : ConstructorDeclarator '

def p_148(p):
  'ConstructorDeclarator : TypeParameters IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '

def p_149(p):
  'ConstructorDeclarator : TypeParameters IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_150(p):
  'ConstructorDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '

def p_151(p):
  'ConstructorDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_152(p):
  'ConstructorBody : LEFT_CURLY ExplicitConstructorInvocation BlockStatements RIGHT_CURLY '

def p_153(p):
  'ConstructorBody : LEFT_CURLY BlockStatements RIGHT_CURLY '

def p_154(p):
  'ConstructorBody : LEFT_CURLY ExplicitConstructorInvocation RIGHT_CURLY '

def p_155(p):
  'ConstructorBody : LEFT_CURLY RIGHT_CURLY '

def p_156(p):
  'ExplicitConstructorInvocation : THIS LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON '

def p_157(p):
  'ExplicitConstructorInvocation : THIS LEFT_PAREN RIGHT_PAREN SEMI_COLON '

def p_158(p):
  'ExplicitConstructorInvocation : SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON '

def p_159(p):
  'ExplicitConstructorInvocation : SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON '

def p_160(p):
  'ExplicitConstructorInvocation : temporary0 SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON '

def p_161(p):
  'ExplicitConstructorInvocation : temporary0 SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON '

def p_162(p):
  'ExplicitConstructorInvocation : Primary DOT SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON '

def p_163(p):
  'ExplicitConstructorInvocation : Primary DOT SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON '

def p_164(p):
  'ClassModifier_enum : PUBLIC ClassModifier_enum '

def p_165(p):
  'ClassModifier_enum : PROTECTED ClassModifier_enum '

def p_166(p):
  'ClassModifier_enum : PRIVATE ClassModifier_enum '

def p_167(p):
  'ClassModifier_enum : ABSTRACT ClassModifier_enum '

def p_168(p):
  'ClassModifier_enum : STATIC ClassModifier_enum '

def p_169(p):
  'ClassModifier_enum : FINAL ClassModifier_enum '

def p_170(p):
  'ClassModifier_enum : STRICTFP ClassModifier_enum '

def p_171(p):
  'ClassModifier_enum : ENUM '

def p_172(p):
  'EnumDeclaration : ClassModifier_enum IDENTIFIER Superinterfaces EnumBody '

def p_173(p):
  'EnumDeclaration : ClassModifier_enum IDENTIFIER EnumBody '

def p_174(p):
  'EnumBody : LEFT_CURLY EnumConstantList COMMA EnumBodyDeclaration RIGHT_CURLY '

def p_175(p):
  'EnumBody : LEFT_CURLY COMMA EnumBodyDeclaration RIGHT_CURLY '

def p_176(p):
  'EnumBody : LEFT_CURLY EnumConstantList EnumBodyDeclaration RIGHT_CURLY '

def p_177(p):
  'EnumBody : LEFT_CURLY EnumConstantList COMMA RIGHT_CURLY '

def p_178(p):
  'EnumBody : LEFT_CURLY EnumConstantList RIGHT_CURLY '

def p_179(p):
  'EnumBody : LEFT_CURLY COMMA RIGHT_CURLY '

def p_180(p):
  'EnumBody : LEFT_CURLY EnumBodyDeclaration RIGHT_CURLY '

def p_181(p):
  'EnumBody : LEFT_CURLY RIGHT_CURLY '

def p_182(p):
  'EnumConstantList : EnumConstantList COMMA EnumConstant '

def p_183(p):
  'EnumConstantList : EnumConstant '

def p_184(p):
  'EnumConstant : IDENTIFIER '

def p_185(p):
  'EnumConstant : IDENTIFIER ClassBody '

def p_186(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_187(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_188(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN RIGHT_PAREN ClassBody '

def p_189(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody '

def p_190(p):
  'EnumBodyDeclaration : SEMI_COLON ClassBodyDeclaration '

def p_191(p):
  'EnumBodyDeclaration : SEMI_COLON '

def p_192(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER TypeParameters ExtendsInterfaces InterfaceBody '

def p_193(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER ExtendsInterfaces InterfaceBody '

def p_194(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER TypeParameters InterfaceBody '

def p_195(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER InterfaceBody '

def p_196(p):
  'InterfaceModifier : PUBLIC InterfaceModifier '

def p_197(p):
  'InterfaceModifier : PROTECTED InterfaceModifier '

def p_198(p):
  'InterfaceModifier : PRIVATE InterfaceModifier '

def p_199(p):
  'InterfaceModifier : ABSTRACT InterfaceModifier '

def p_200(p):
  'InterfaceModifier : STATIC InterfaceModifier '

def p_201(p):
  'InterfaceModifier : STRICTFP InterfaceModifier '

def p_202(p):
  'InterfaceModifier : INTERFACE '

def p_203(p):
  'ExtendsInterfaces : EXTENDS InterfaceTypeList '

def p_204(p):
  'InterfaceBody : LEFT_CURLY InterfaceMemberDeclaration RIGHT_CURLY '

def p_205(p):
  'InterfaceBody : LEFT_CURLY RIGHT_CURLY '

def p_206(p):
  'InterfaceMemberDeclaration : ConstantDeclaration '

def p_207(p):
  'InterfaceMemberDeclaration : InterfaceMethodDeclaration '

def p_208(p):
  'InterfaceMemberDeclaration : ClassDeclaration '

def p_209(p):
  'InterfaceMemberDeclaration : InterfaceDeclaration '

def p_210(p):
  'InterfaceMemberDeclaration : SEMI_COLON '

def p_211(p):
  'InterfaceMemberDeclaration : InterfaceMemberDeclaration ConstantDeclaration '

def p_212(p):
  'InterfaceMemberDeclaration : InterfaceMemberDeclaration InterfaceMethodDeclaration '

def p_213(p):
  'InterfaceMemberDeclaration : InterfaceMemberDeclaration ClassDeclaration '

def p_214(p):
  'InterfaceMemberDeclaration : InterfaceMemberDeclaration InterfaceDeclaration '

def p_215(p):
  'InterfaceMemberDeclaration : InterfaceMemberDeclaration SEMI_COLON '

def p_216(p):
  'ConstantDeclaration : ConstantModifier SEMI_COLON '

def p_217(p):
  'ConstantModifier : PUBLIC ConstantModifier '

def p_218(p):
  'ConstantModifier : STATIC ConstantModifier '

def p_219(p):
  'ConstantModifier : FINAL ConstantModifier '

def p_220(p):
  'ConstantModifier : Type VariableDeclaratorList '

def p_221(p):
  'InterfaceMethodModifier : PUBLIC InterfaceMethodModifier '

def p_222(p):
  'InterfaceMethodModifier : PROTECTED InterfaceMethodModifier '

def p_223(p):
  'InterfaceMethodModifier : PRIVATE InterfaceMethodModifier '

def p_224(p):
  'InterfaceMethodModifier : ABSTRACT InterfaceMethodModifier '

def p_225(p):
  'InterfaceMethodModifier : STATIC InterfaceMethodModifier '

def p_226(p):
  'InterfaceMethodModifier : STRICTFP InterfaceMethodModifier '

def p_227(p):
  'InterfaceMethodModifier : MethodHeader '

def p_228(p):
  'InterfaceMethodDeclaration : InterfaceMethodModifier MethodBody '

def p_229(p):
  'InterfaceMethodDeclaration : AT_RATE InterfaceMethodModifier MethodBody '

def p_230(p):
  'ArrayInitializer : LEFT_CURLY VariableInitializerList COMMA RIGHT_CURLY '

def p_231(p):
  'ArrayInitializer : LEFT_CURLY COMMA RIGHT_CURLY '

def p_232(p):
  'ArrayInitializer : LEFT_CURLY VariableInitializerList RIGHT_CURLY '

def p_233(p):
  'ArrayInitializer : LEFT_CURLY RIGHT_CURLY '

def p_234(p):
  'VariableInitializerList : VariableInitializerList COMMA VariableInitializer '

def p_235(p):
  'VariableInitializerList : VariableInitializer '

def p_236(p):
  'Block : LEFT_CURLY BlockStatements RIGHT_CURLY '

def p_237(p):
  'Block : LEFT_CURLY RIGHT_CURLY '

def p_238(p):
  'BlockStatements : BlockStatements BlockStatement '

def p_239(p):
  'BlockStatements : BlockStatement '

def p_240(p):
  'BlockStatement : LocalVariableDeclarationStatement '

def p_241(p):
  'BlockStatement : ClassDeclaration '

def p_242(p):
  'BlockStatement : Statement '

def p_243(p):
  'LocalVariableDeclarationStatement : LocalVariableDeclaration SEMI_COLON '

def p_244(p):
  'LocalVariableDeclaration : FINAL Type VariableDeclaratorList '

def p_245(p):
  'LocalVariableDeclaration : Type VariableDeclaratorList '

def p_246(p):
  'Statement : StatementWithoutTrailingSubstatement '

def p_247(p):
  'Statement : LabeledStatement '

def p_248(p):
  'Statement : IfThenStatement '

def p_249(p):
  'Statement : IfThenElseStatement '

def p_250(p):
  'Statement : WhileStatement '

def p_251(p):
  'Statement : ForStatement '

def p_252(p):
  'StatementNoShortIf : StatementWithoutTrailingSubstatement '

def p_253(p):
  'StatementNoShortIf : LabeledStatementNoShortIf '

def p_254(p):
  'StatementNoShortIf : IfThenElseStatementNoShortIf '

def p_255(p):
  'StatementNoShortIf : WhileStatementNoShortIf '

def p_256(p):
  'StatementNoShortIf : ForStatementNoShortIf '

def p_257(p):
  'StatementWithoutTrailingSubstatement : Block '

def p_258(p):
  'StatementWithoutTrailingSubstatement : SEMI_COLON '

def p_259(p):
  'StatementWithoutTrailingSubstatement : ExpressionStatement '

def p_260(p):
  'StatementWithoutTrailingSubstatement : AssertStatement '

def p_261(p):
  'StatementWithoutTrailingSubstatement : SwitchStatement '

def p_262(p):
  'StatementWithoutTrailingSubstatement : DoStatement '

def p_263(p):
  'StatementWithoutTrailingSubstatement : BreakStatement '

def p_264(p):
  'StatementWithoutTrailingSubstatement : ContinueStatement '

def p_265(p):
  'StatementWithoutTrailingSubstatement : ReturnStatement '

def p_266(p):
  'StatementWithoutTrailingSubstatement : SynchronizedStatement '

def p_267(p):
  'StatementWithoutTrailingSubstatement : ThrowStatement '

def p_268(p):
  'StatementWithoutTrailingSubstatement : TryStatement '

def p_269(p):
  'LabeledStatement : IDENTIFIER COLON Statement '

def p_270(p):
  'LabeledStatementNoShortIf : IDENTIFIER COLON StatementNoShortIf '

def p_271(p):
  'ExpressionStatement : StatementExpression SEMI_COLON '

def p_272(p):
  'StatementExpression : Assignment '

def p_273(p):
  'StatementExpression : PreIncrementExpression '

def p_274(p):
  'StatementExpression : PreDecrementExpression '

def p_275(p):
  'StatementExpression : PostIncrementExpression '

def p_276(p):
  'StatementExpression : PostDecrementExpression '

def p_277(p):
  'StatementExpression : MethodInvocation '

def p_278(p):
  'StatementExpression : ClassInstanceCreationExpression '

def p_279(p):
  'IfThenStatement : IF LEFT_PAREN Expression RIGHT_PAREN Statement '

def p_280(p):
  'IfThenElseStatement : IF LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf ELSE Statement '

def p_281(p):
  'IfThenElseStatementNoShortIf : IF LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf ELSE StatementNoShortIf '

def p_282(p):
  'AssertStatement : ASSERT Expression SEMI_COLON '

def p_283(p):
  'AssertStatement : ASSERT Expression COLON Expression SEMI_COLON '

def p_284(p):
  'SwitchStatement : SWITCH LEFT_PAREN Expression RIGHT_PAREN SwitchBlock '

def p_285(p):
  'SwitchBlock : LEFT_CURLY SwitchBlockStatementGroup SwitchLabels RIGHT_CURLY '

def p_286(p):
  'SwitchBlock : LEFT_CURLY SwitchLabels RIGHT_CURLY '

def p_287(p):
  'SwitchBlock : LEFT_CURLY SwitchBlockStatementGroup RIGHT_CURLY '

def p_288(p):
  'SwitchBlock : LEFT_CURLY RIGHT_CURLY '

def p_289(p):
  'SwitchBlockStatementGroup : SwitchBlockStatementGroup SwitchLabels BlockStatements '

def p_290(p):
  'SwitchBlockStatementGroup : SwitchLabels BlockStatements '

def p_291(p):
  'SwitchLabels : SwitchLabels SwitchLabel '

def p_292(p):
  'SwitchLabels : SwitchLabel '

def p_293(p):
  'SwitchLabel : CASE ConstantExpression COLON '

def p_294(p):
  'SwitchLabel : DEFAULT COLON '

def p_295(p):
  'WhileStatement : WHILE LEFT_PAREN Expression RIGHT_PAREN Statement '

def p_296(p):
  'WhileStatementNoShortIf : WHILE LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf '

def p_297(p):
  'DoStatement : DO Statement WHILE LEFT_PAREN Expression RIGHT_PAREN SEMI_COLON '

def p_298(p):
  'ForStatement : BasicForStatement '

def p_299(p):
  'ForStatement : EnhancedForStatement '

def p_300(p):
  'ForStatementNoShortIf : BasicForStatementNoShortIf '

def p_301(p):
  'ForStatementNoShortIf : EnhancedForStatementNoShortIf '

def p_302(p):
  'BasicForStatement : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN Statement '

def p_303(p):
  'BasicForStatement : FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN Statement '

def p_304(p):
  'BasicForStatement : FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN Statement '

def p_305(p):
  'BasicForStatement : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON RIGHT_PAREN Statement '

def p_306(p):
  'BasicForStatement : FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON RIGHT_PAREN Statement '

def p_307(p):
  'BasicForStatement : FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON RIGHT_PAREN Statement '

def p_308(p):
  'BasicForStatement : FOR LEFT_PAREN SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN Statement '

def p_309(p):
  'BasicForStatement : FOR LEFT_PAREN SEMI_COLON SEMI_COLON RIGHT_PAREN Statement '

def p_310(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf '

def p_311(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf '

def p_312(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf '

def p_313(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON RIGHT_PAREN StatementNoShortIf '

def p_314(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON RIGHT_PAREN StatementNoShortIf '

def p_315(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON RIGHT_PAREN StatementNoShortIf '

def p_316(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf '

def p_317(p):
  'BasicForStatementNoShortIf : FOR LEFT_PAREN SEMI_COLON SEMI_COLON RIGHT_PAREN StatementNoShortIf '

def p_318(p):
  'ForInit : StatementExpressionList '

def p_319(p):
  'ForInit : LocalVariableDeclaration '

def p_320(p):
  'ForUpdate : StatementExpressionList '

def p_321(p):
  'StatementExpressionList : StatementExpressionList COMMA StatementExpression '

def p_322(p):
  'StatementExpressionList : StatementExpression '

def p_323(p):
  'EnhancedForStatement : FOR LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement '

def p_324(p):
  'EnhancedForStatement : FOR LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement '

def p_325(p):
  'EnhancedForStatementNoShortIf : FOR LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf '

def p_326(p):
  'EnhancedForStatementNoShortIf : FOR LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf '

def p_327(p):
  'BreakStatement : BREAK IDENTIFIER SEMI_COLON '

def p_328(p):
  'BreakStatement : BREAK SEMI_COLON '

def p_329(p):
  'ContinueStatement : CONTINUE IDENTIFIER SEMI_COLON '

def p_330(p):
  'ContinueStatement : CONTINUE SEMI_COLON '

def p_331(p):
  'ReturnStatement : RETURN Expression SEMI_COLON '

def p_332(p):
  'ReturnStatement : RETURN SEMI_COLON '

def p_333(p):
  'ThrowStatement : THROW Expression SEMI_COLON '

def p_334(p):
  'SynchronizedStatement : SYNCHRONIZED LEFT_PAREN Expression RIGHT_PAREN Block '

def p_335(p):
  'TryStatement : TRY Block Catches '

def p_336(p):
  'TryStatement : TRY Block Catches Finally '

def p_337(p):
  'TryStatement : TRY Block Finally '

def p_338(p):
  'TryStatement : TryWithResourcesStatement '

def p_339(p):
  'Catches : Catches CatchClause '

def p_340(p):
  'Catches : CatchClause '

def p_341(p):
  'CatchClause : CATCH LEFT_PAREN CatchFormalParameter RIGHT_PAREN Block '

def p_342(p):
  'CatchFormalParameter : FINAL CatchType VariableDeclaratorId '

def p_343(p):
  'CatchFormalParameter : CatchType VariableDeclaratorId '

def p_344(p):
  'CatchType : CatchType LOR ClassType '

def p_345(p):
  'CatchType : ClassType '

def p_346(p):
  'Finally : FINALLY Block '

def p_347(p):
  'TryWithResourcesStatement : TRY ResourcesSpecification Block Catches Finally '

def p_348(p):
  'TryWithResourcesStatement : TRY ResourcesSpecification Block Finally '

def p_349(p):
  'TryWithResourcesStatement : TRY ResourcesSpecification Block Catches '

def p_350(p):
  'TryWithResourcesStatement : TRY ResourcesSpecification Block '

def p_351(p):
  'ResourcesSpecification : LEFT_PAREN ResourceList SEMI_COLON RIGHT_PAREN '

def p_352(p):
  'ResourcesSpecification : LEFT_PAREN ResourceList RIGHT_PAREN '

def p_353(p):
  'ResourceList : ResourceList SEMI_COLON Resource '

def p_354(p):
  'ResourceList : Resource '

def p_355(p):
  'Resource : FINAL Type VariableDeclaratorId ASSIGN Expression '

def p_356(p):
  'Resource : Type VariableDeclaratorId ASSIGN Expression '

def p_357(p):
  'Primary : PrimaryNoNewArray '

def p_358(p):
  'Primary : ArrayCreationExpression '

def p_359(p):
  'PrimaryNoNewArray : Literal '

def p_360(p):
  'PrimaryNoNewArray : ClassLiteral '

def p_361(p):
  'PrimaryNoNewArray : THIS '

def p_362(p):
  'PrimaryNoNewArray : temporary0 THIS '

def p_363(p):
  'PrimaryNoNewArray : LEFT_PAREN Expression RIGHT_PAREN '

def p_364(p):
  'PrimaryNoNewArray : ClassInstanceCreationExpression '

def p_365(p):
  'PrimaryNoNewArray : FieldAccess '

def p_366(p):
  'PrimaryNoNewArray : ArrayAccess '

def p_367(p):
  'PrimaryNoNewArray : MethodInvocation '

def p_368(p):
  'PrimaryNoNewArray : MethodReference '

def p_369(p):
  'ClassLiteral : ClassType Dims DOT CLASS '

def p_370(p):
  'ClassLiteral : PrimitiveType Dims DOT CLASS '

def p_371(p):
  'ClassLiteral : temporary0 CLASS '

def p_372(p):
  'ClassLiteral : PrimitiveType DOT CLASS '

def p_373(p):
  'ClassLiteral : VOID DOT CLASS '

def p_374(p):
  'Literal : INTEGER_LIT '

def p_375(p):
  'Literal : FLOATING_LIT '

def p_376(p):
  'Literal : BOOLEAN_LIT '

def p_377(p):
  'Literal : CHAR_LIT '

def p_378(p):
  'Literal : STRING_LIT '

def p_379(p):
  'Literal : NULL_LIT '

def p_380(p):
  'ClassInstanceCreationExpression : UnqualifiedClassInstanceCreationExpression '

def p_381(p):
  'ClassInstanceCreationExpression : temporary0 UnqualifiedClassInstanceCreationExpression '

def p_382(p):
  'ClassInstanceCreationExpression : Primary DOT UnqualifiedClassInstanceCreationExpression '

def p_383(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody '

def p_384(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_385(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN ClassBody '

def p_386(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN '

def p_387(p):
  'ClassOrInterfaceTypeToInstantiate : TypeName '

def p_388(p):
  'FieldAccess : Primary DOT IDENTIFIER '

def p_389(p):
  'FieldAccess : SUPER DOT IDENTIFIER '

def p_390(p):
  'FieldAccess : temporary0 SUPER DOT IDENTIFIER '

def p_391(p):
  'ArrayAccess : ClassType LEFT_SQUARE Expression RIGHT_SQUARE '

def p_392(p):
  'ArrayAccess : PrimaryNoNewArray LEFT_SQUARE Expression RIGHT_SQUARE '

def p_393(p):
  'MethodInvocation : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_394(p):
  'MethodInvocation : IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_395(p):
  'MethodInvocation : temporary0 IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_396(p):
  'MethodInvocation : temporary0 IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_397(p):
  'MethodInvocation : Primary DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_398(p):
  'MethodInvocation : Primary DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_399(p):
  'MethodInvocation : SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_400(p):
  'MethodInvocation : SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_401(p):
  'MethodInvocation : temporary0 SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '

def p_402(p):
  'MethodInvocation : temporary0 SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '

def p_403(p):
  'ArgumentList : ArgumentList COMMA Expression '

def p_404(p):
  'ArgumentList : Expression '

def p_405(p):
  'MethodReference : ReferenceType DOUBLE_COLON IDENTIFIER '

def p_406(p):
  'MethodReference : Primary DOUBLE_COLON IDENTIFIER '

def p_407(p):
  'MethodReference : SUPER DOUBLE_COLON IDENTIFIER '

def p_408(p):
  'MethodReference : temporary0 SUPER DOUBLE_COLON IDENTIFIER '

def p_409(p):
  'MethodReference : ReferenceType DOUBLE_COLON NEW '

def p_410(p):
  'ArrayCreationExpression : NEW PrimitiveType DimExprs Dims '

def p_411(p):
  'ArrayCreationExpression : NEW PrimitiveType DimExprs '

def p_412(p):
  'ArrayCreationExpression : NEW ClassType DimExprs Dims '

def p_413(p):
  'ArrayCreationExpression : NEW ClassType DimExprs '

def p_414(p):
  'ArrayCreationExpression : NEW PrimitiveType Dims ArrayInitializer '

def p_415(p):
  'ArrayCreationExpression : NEW ClassType Dims ArrayInitializer '

def p_416(p):
  'DimExprs : DimExprs DimExpr '

def p_417(p):
  'DimExprs : DimExpr '

def p_418(p):
  'DimExpr : LEFT_SQUARE Expression RIGHT_SQUARE '

def p_419(p):
  'Expression : AssignmentExpression '

def p_420(p):
  'Expression : LambdaExpression '

def p_421(p):
  'LambdaExpression : LambdaParameters LambdaBody '

def p_422(p):
  'LambdaParameters : IDENTIFIER POINTER '

def p_423(p):
  'LambdaParameters : LEFT_PAREN FormalParameterList RPOINTER '

def p_424(p):
  'LambdaParameters : LEFT_PAREN IDENTIFIER InferredFormalParameterList RPOINTER '

def p_425(p):
  'LambdaParameters : LEFT_PAREN IDENTIFIER RPOINTER '

def p_426(p):
  'InferredFormalParameterList : InferredFormalParameterList COMMA IDENTIFIER '

def p_427(p):
  'InferredFormalParameterList : COMMA IDENTIFIER '

def p_428(p):
  'LambdaBody : Expression '

def p_429(p):
  'LambdaBody : Block '

def p_430(p):
  'AssignmentExpression : ConditionalExpression '

def p_431(p):
  'AssignmentExpression : Assignment '

def p_432(p):
  'Assignment : LeftHandSide AssignmentOperator Expression '

def p_433(p):
  'LeftHandSide : ClassType '

def p_434(p):
  'LeftHandSide : FieldAccess '

def p_435(p):
  'LeftHandSide : ArrayAccess '

def p_436(p):
  'AssignmentOperator : ASSIGN '

def p_437(p):
  'AssignmentOperator : MULASSN '

def p_438(p):
  'AssignmentOperator : DIVASSN '

def p_439(p):
  'AssignmentOperator : MODASSN '

def p_440(p):
  'AssignmentOperator : ADDASSN '

def p_441(p):
  'AssignmentOperator : SUBASSN '

def p_442(p):
  'AssignmentOperator : LSHIFTASSN '

def p_443(p):
  'AssignmentOperator : RSHIFTASSN '

def p_444(p):
  'AssignmentOperator : RRSHIFTASSN '

def p_445(p):
  'AssignmentOperator : ANDASSN '

def p_446(p):
  'AssignmentOperator : XORASSN '

def p_447(p):
  'AssignmentOperator : ORASSN '

def p_448(p):
  'ConditionalExpression : ConditionalOrExpression '

def p_449(p):
  'ConditionalExpression : ConditionalOrExpression TERNARY Expression COLON ConditionalExpression '

def p_450(p):
  'ConditionalExpression : ConditionalOrExpression TERNARY Expression COLON LambdaExpression '

def p_451(p):
  'ConditionalOrExpression : ConditionalAndExpression '

def p_452(p):
  'ConditionalOrExpression : ConditionalOrExpression BOR ConditionalAndExpression '

def p_453(p):
  'ConditionalAndExpression : InclusiveOrExpression '

def p_454(p):
  'ConditionalAndExpression : ConditionalAndExpression BAND InclusiveOrExpression '

def p_455(p):
  'InclusiveOrExpression : ExclusiveOrExpression '

def p_456(p):
  'InclusiveOrExpression : InclusiveOrExpression LOR ExclusiveOrExpression '

def p_457(p):
  'ExclusiveOrExpression : AndExpression '

def p_458(p):
  'ExclusiveOrExpression : ExclusiveOrExpression LXOR AndExpression '

def p_459(p):
  'AndExpression : EqualityExpression '

def p_460(p):
  'AndExpression : AndExpression LAND EqualityExpression '

def p_461(p):
  'EqualityExpression : RelationalExpression '

def p_462(p):
  'EqualityExpression : EqualityExpression EQUAL RelationalExpression '

def p_463(p):
  'EqualityExpression : EqualityExpression NOTEQ RelationalExpression '

def p_464(p):
  'RelationalExpression : ShiftExpression '

def p_465(p):
  'RelationalExpression : RelationalExpression LT ShiftExpression '

def p_466(p):
  'RelationalExpression : RelationalExpression GT ShiftExpression '

def p_467(p):
  'RelationalExpression : RelationalExpression LTE ShiftExpression '

def p_468(p):
  'RelationalExpression : RelationalExpression GTE ShiftExpression '

def p_469(p):
  'RelationalExpression : RelationalExpression INSTANCEOF ReferenceType '

def p_470(p):
  'ShiftExpression : AdditiveExpression '

def p_471(p):
  'ShiftExpression : ShiftExpression LSHIFT AdditiveExpression '

def p_472(p):
  'ShiftExpression : ShiftExpression RSHIFT AdditiveExpression '

def p_473(p):
  'ShiftExpression : ShiftExpression RRSHIFT AdditiveExpression '

def p_474(p):
  'AdditiveExpression : MultiplicativeExpression '

def p_475(p):
  'AdditiveExpression : AdditiveExpression ADD MultiplicativeExpression '

def p_476(p):
  'AdditiveExpression : AdditiveExpression SUB MultiplicativeExpression '

def p_477(p):
  'MultiplicativeExpression : UnaryExpression '

def p_478(p):
  'MultiplicativeExpression : MultiplicativeExpression MUL UnaryExpression '

def p_479(p):
  'MultiplicativeExpression : MultiplicativeExpression DIV UnaryExpression '

def p_480(p):
  'MultiplicativeExpression : MultiplicativeExpression MOD UnaryExpression '

def p_481(p):
  'UnaryExpression : PreIncrementExpression '

def p_482(p):
  'UnaryExpression : PreDecrementExpression '

def p_483(p):
  'UnaryExpression : ADD UnaryExpression '

def p_484(p):
  'UnaryExpression : SUB UnaryExpression '

def p_485(p):
  'UnaryExpression : UnaryExpressionNotPlusMinus '

def p_486(p):
  'PreIncrementExpression : INC UnaryExpression '

def p_487(p):
  'PreDecrementExpression : DEC UnaryExpression '

def p_488(p):
  'UnaryExpressionNotPlusMinus : PostfixExpression '

def p_489(p):
  'UnaryExpressionNotPlusMinus : NEG UnaryExpression '

def p_490(p):
  'UnaryExpressionNotPlusMinus : NOT UnaryExpression '

def p_491(p):
  'UnaryExpressionNotPlusMinus : LEFT_PAREN PrimitiveType RIGHT_PAREN UnaryExpression '

def p_492(p):
  'PostfixExpression : Primary '

def p_493(p):
  'PostfixExpression : PostFixType '

def p_494(p):
  'PostfixExpression : PostIncrementExpression '

def p_495(p):
  'PostfixExpression : PostDecrementExpression '

def p_496(p):
  'PostIncrementExpression : PostfixExpression INC '

def p_497(p):
  'PostDecrementExpression : PostfixExpression DEC '

def p_498(p):
  'ConstantExpression : Expression '

def p_error(p):
  print(p)
  print("Syntax error in input!")

if __name__ == '__main__':
  lexer = lex.lex(module = lexer)
  parser = yacc.yacc(start = 'CompilationUnit')
  in_file = open(sys.argv[1], 'r')
  data = in_file.read()
  in_file.close()
  result = parser.parse(data)
  print(result)
