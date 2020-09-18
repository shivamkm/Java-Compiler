%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <getopt.h>

#define YYDEBUG 1

long int counter = 0;
long int label_counter = 0;
using namespace std;
extern FILE *yyin, *yyout;
FILE* outfile;
int yylex (void);
extern char* yytext;
extern int yylineno;

void yyerror(const char* message)
{
  printf("%s\n", message);
  printf("Error at %s at line number %d\n", yytext, yylineno);
  if(strlen(yytext) >= 1)
  {
    if(yytext[0] == '<')
    {
      printf("Type Arguments are not supported!\n");
    }
    if(yytext[0] == '@')
    {
      printf("Annotations other than @Override are not supported!\n");
    }
  }
  exit(-1);
}

%}

%union
{
  long int integer;
  char* str;
  double fraction;
  bool truth;
  char character;
}

%glr-parser
%define lr.type lalr
%token <str> IDENTIFIER

%token <str> LEFT_PAREN
%token <str> RIGHT_PAREN
%token <str> LEFT_CURLY
%token <str> RIGHT_CURLY
%token <str> LEFT_SQUARE
%token <str> RIGHT_SQUARE
%token <str> SEMI_COLON
%token <str> COMMA
%token <str> DOT
%token <str> TRIPLE_DOT
%token <str> AT_RATE
%token <str> DOUBLE_COLON

%token <str> ASSIGN
%token <str> GT
%token <str> LT
%token <str> NOT
%token <str> NEG
%token <str> TERNARY
%token <str> COLON
%token <str> POINTER
%token <str> RPOINTER
%token <str> EQUAL
%token <str> GTE
%token <str> LTE
%token <str> NOTEQ
%token <str> BAND
%token <str> BOR
%token <str> INC
%token <str> DEC
%token <str> ADD
%token <str> SUB
%token <str> MUL
%token <str> DIV
%token <str> LAND
%token <str> LOR
%token <str> LXOR
%token <str> MOD
%token <str> LSHIFT
%token <str> RSHIFT
%token <str> RRSHIFT
%token <str> ADDASSN
%token <str> SUBASSN
%token <str> MULASSN
%token <str> DIVASSN
%token <str> ANDASSN
%token <str> ORASSN
%token <str> XORASSN
%token <str> MODASSN
%token <str> LSHIFTASSN
%token <str> RSHIFTASSN
%token <str> RRSHIFTASSN

%token <truth> BOOLEAN_LIT
%token <character> CHAR_LIT
%token <str> NULL_LIT
%token <str> STRING_LIT
%token <integer> INTEGER_LIT
%token <fraction> FLOATING_LIT

%token <str> ABSTRACT
%token <str> CONTINUE
%token <str> FOR
%token <str> NEW
%token <str> SWITCH
%token <str> ASSERT
%token <str> DEFAULT
%token <str> IF
%token <str> PACKAGE
%token <str> SYNCHRONIZED
%token <str> BOOLEAN
%token <str> DO
%token <str> GOTO
%token <str> PRIVATE
%token <str> THIS
%token <str> BREAK
%token <str> DOUBLE
%token <str> IMPLEMENTS
%token <str> PROTECTED
%token <str> THROW
%token <str> BYTE
%token <str> ELSE
%token <str> IMPORT
%token <str> PUBLIC
%token <str> THROWS
%token <str> CASE
%token <str> ENUM
%token <str> INSTANCEOF
%token <str> RETURN
%token <str> TRANSIENT
%token <str> CATCH
%token <str> EXTENDS
%token <str> INT
%token <str> SHORT
%token <str> TRY
%token <str> CHAR
%token <str> FINAL
%token <str> INTERFACE
%token <str> STATIC
%token <str> VOID
%token <str> CLASS
%token <str> FINALLY
%token <str> LONG
%token <str> STRICTFP
%token <str> VOLATILE
%token <str> CONST
%token <str> FLOAT
%token <str> NATIVE
%token <str> SUPER
%token <str> WHILE

%type <str> TypeName
%type <str> Type
%type <str> PrimitiveType
%type <str> NumericType
%type <str> ReferenceType
%type <str> temporary0
%type <str> ClassType
%type <str> PostFixType
%type <str> ArrayType
%type <str> Dims
%type <str> TypeParameter
%type <str> TypeBound
%type <str> AdditionalBound
%type <str> CompilationUnit
%type <str> PackageDeclaration
%type <str> ImportDeclaration
%type <str> TypeDeclaration
%type <str> ClassDeclaration
%type <str> NormalClassDeclaration
%type <str> ClassModifier
%type <str> TypeParameters
%type <str> TypeParameterList
%type <str> SuperClass
%type <str> Superinterfaces
%type <str> InterfaceTypeList
%type <str> ClassBody
%type <str> ClassBodyDeclaration
%type <str> ClassMemberDeclaration
%type <str> FieldDeclaration
%type <str> FieldModifier
%type <str> VariableDeclaratorList
%type <str> VariableDeclarator
%type <str> VariableDeclaratorId
%type <str> VariableInitializer
%type <str> MethodDeclaration
%type <str> MethodHeader
%type <str> MethodDeclarator
%type <str> FormalParameterList
%type <str> FormalParameters
%type <str> FormalParameter
%type <str> LastFormalParameter
%type <str> ReceiverParameter
%type <str> Throws
%type <str> ExceptionTypeList
%type <str> MethodBody
%type <str> ConstructorDeclaration
%type <str> ConstructorModifier
%type <str> ConstructorDeclarator
%type <str> ConstructorBody
%type <str> ExplicitConstructorInvocation
%type <str> ClassModifier_enum
%type <str> EnumDeclaration
%type <str> EnumBody
%type <str> EnumConstantList
%type <str> EnumConstant
%type <str> EnumBodyDeclaration
%type <str> InterfaceDeclaration
%type <str> InterfaceModifier
%type <str> ExtendsInterfaces
%type <str> InterfaceBody
%type <str> InterfaceMemberDeclaration
%type <str> ConstantDeclaration
%type <str> ConstantModifier
%type <str> InterfaceMethodModifier
%type <str> InterfaceMethodDeclaration
%type <str> ArrayInitializer
%type <str> VariableInitializerList
%type <str> Block
%type <str> BlockStatements
%type <str> BlockStatement
%type <str> LocalVariableDeclarationStatement
%type <str> LocalVariableDeclaration
%type <str> Statement
%type <str> StatementNoShortIf
%type <str> StatementWithoutTrailingSubstatement
%type <str> LabeledStatement
%type <str> LabeledStatementNoShortIf
%type <str> ExpressionStatement
%type <str> StatementExpression
%type <str> IfThenStatement
%type <str> IfThenElseStatement
%type <str> IfThenElseStatementNoShortIf
%type <str> AssertStatement
%type <str> SwitchStatement
%type <str> SwitchBlock
%type <str> SwitchBlockStatementGroup
%type <str> SwitchLabels
%type <str> SwitchLabel
%type <str> WhileStatement
%type <str> WhileStatementNoShortIf
%type <str> DoStatement
%type <str> ForStatement
%type <str> ForStatementNoShortIf
%type <str> BasicForStatement
%type <str> BasicForStatementNoShortIf
%type <str> ForInit
%type <str> ForUpdate
%type <str> StatementExpressionList
%type <str> EnhancedForStatement
%type <str> EnhancedForStatementNoShortIf
%type <str> BreakStatement
%type <str> ContinueStatement
%type <str> ReturnStatement
%type <str> ThrowStatement
%type <str> SynchronizedStatement
%type <str> TryStatement
%type <str> Catches
%type <str> CatchClause
%type <str> CatchFormalParameter
%type <str> CatchType
%type <str> Finally
%type <str> TryWithResourcesStatement
%type <str> ResourcesSpecification
%type <str> ResourceList
%type <str> Resource
%type <str> Primary
%type <str> PrimaryNoNewArray
%type <str> ClassLiteral
%type <str> Literal
%type <str> ClassInstanceCreationExpression
%type <str> UnqualifiedClassInstanceCreationExpression
%type <str> ClassOrInterfaceTypeToInstantiate
%type <str> FieldAccess
%type <str> ArrayAccess
%type <str> MethodInvocation
%type <str> ArgumentList
%type <str> MethodReference
%type <str> ArrayCreationExpression
%type <str> DimExprs
%type <str> DimExpr
%type <str> Expression
%type <str> LambdaExpression
%type <str> LambdaParameters
%type <str> InferredFormalParameterList
%type <str> LambdaBody
%type <str> AssignmentExpression
%type <str> Assignment
%type <str> LeftHandSide
%type <str> AssignmentOperator
%type <str> ConditionalExpression
%type <str> ConditionalOrExpression
%type <str> ConditionalAndExpression
%type <str> InclusiveOrExpression
%type <str> ExclusiveOrExpression
%type <str> AndExpression
%type <str> EqualityExpression
%type <str> RelationalExpression
%type <str> ShiftExpression
%type <str> AdditiveExpression
%type <str> MultiplicativeExpression
%type <str> UnaryExpression
%type <str> PreIncrementExpression
%type <str> PreDecrementExpression
%type <str> UnaryExpressionNotPlusMinus
%type <str> PostfixExpression
%type <str> PostIncrementExpression
%type <str> PostDecrementExpression
%type <str> ConstantExpression

%left INC DEC
%left MUL DIV MOD
%left ADD SUB
%left LSHIFT RSHIFT
%left GT GTE LT LTE
%left EQUAL NOTEQ
%left BAND
%left BOR
%left LAND
%left LOR
%right ASSIGN ADDASSN SUBASSN MULASSN DIVASSN MODASSN LSHIFTASSN RSHIFTASSN ANDASSN ORASSN XORASSN

%start CompilationUnit

%%


TypeName : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeName_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeName_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


Type : PrimitiveType
{
  $$ = $1;
}
| ReferenceType
{
  $$ = $1;
}


PrimitiveType : NumericType
{
  $$ = $1;
}
| BOOLEAN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PrimitiveType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


NumericType : BYTE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SHORT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| INT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LONG
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| CHAR
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| FLOAT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| DOUBLE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NumericType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ReferenceType : ClassType
{
  $$ = $1;
}
| ArrayType
{
  $$ = $1;
}


temporary0 : temporary0 IDENTIFIER DOT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "temporary0_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER DOT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "temporary0_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassType : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassType_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


PostFixType : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PostFixType_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PostFixType_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ArrayType : PrimitiveType Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayType_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ClassType Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayType_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


Dims : LEFT_SQUARE RIGHT_SQUARE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Dims_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Dims LEFT_SQUARE RIGHT_SQUARE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Dims_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


TypeParameter : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeParameter_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER TypeBound
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeParameter_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


TypeBound : EXTENDS IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeBound_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| EXTENDS ClassType AdditionalBound
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeBound_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


AdditionalBound : LAND ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AdditionalBound_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| AdditionalBound LAND ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AdditionalBound_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


CompilationUnit : PackageDeclaration ImportDeclaration TypeDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| PackageDeclaration ImportDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PackageDeclaration TypeDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PackageDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
}
| ImportDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
}
| TypeDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
}
| ImportDeclaration TypeDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| %empty
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CompilationUnit_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> \"\"\n", $$);
}


PackageDeclaration : PACKAGE TypeName SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PackageDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ImportDeclaration : IMPORT TypeName SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IMPORT temporary0 MUL SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IMPORT STATIC temporary0 IDENTIFIER SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IMPORT STATIC temporary0 MUL SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ImportDeclaration IMPORT TypeName SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ImportDeclaration IMPORT temporary0 MUL SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ImportDeclaration IMPORT STATIC temporary0 IDENTIFIER SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ImportDeclaration IMPORT STATIC temporary0 MUL SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ImportDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


TypeDeclaration : ClassDeclaration
{
  $$ = $1;
}
| InterfaceDeclaration
{
  $$ = $1;
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| TypeDeclaration ClassDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| TypeDeclaration InterfaceDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| TypeDeclaration SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassDeclaration : NormalClassDeclaration
{
  $$ = $1;
}
| EnumDeclaration
{
  $$ = $1;
}


NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters SuperClass Superinterfaces ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "%s -> %s\n", $$, $6);
}
| ClassModifier IDENTIFIER TypeParameters SuperClass ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| ClassModifier IDENTIFIER TypeParameters Superinterfaces ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| ClassModifier IDENTIFIER SuperClass Superinterfaces ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| ClassModifier IDENTIFIER TypeParameters ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| ClassModifier IDENTIFIER SuperClass ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| ClassModifier IDENTIFIER Superinterfaces ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| ClassModifier IDENTIFIER ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "NormalClassDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ClassModifier : PUBLIC ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ABSTRACT ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| FINAL ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STRICTFP ClassModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


TypeParameters : LT TypeParameterList GT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeParameters_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


TypeParameterList : TypeParameterList COMMA TypeParameter
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TypeParameterList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| TypeParameter
{
  $$ = $1;
}


SuperClass : EXTENDS ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SuperClass_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


Superinterfaces : IMPLEMENTS InterfaceTypeList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Superinterfaces_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


InterfaceTypeList : InterfaceTypeList COMMA ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceTypeList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ClassType
{
  $$ = $1;
}


ClassBody : LEFT_CURLY ClassBodyDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassBodyDeclaration : ClassMemberDeclaration
{
  $$ = $1;
}
| Block
{
  $$ = $1;
}
| STATIC Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ConstructorDeclaration
{
  $$ = $1;
}
| ClassBodyDeclaration ClassMemberDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ClassBodyDeclaration Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ClassBodyDeclaration STATIC Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ClassBodyDeclaration ConstructorDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


ClassMemberDeclaration : FieldDeclaration
{
  $$ = $1;
}
| MethodDeclaration
{
  $$ = $1;
}
| ClassDeclaration
{
  $$ = $1;
}
| InterfaceDeclaration
{
  $$ = $1;
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


FieldDeclaration : FieldModifier SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


FieldModifier : PUBLIC FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| FINAL FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| TRANSIENT FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| VOLATILE FieldModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| Type VariableDeclaratorList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldModifier_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


VariableDeclaratorList : VariableDeclaratorList COMMA VariableDeclarator
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "VariableDeclaratorList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| VariableDeclarator
{
  $$ = $1;
}


VariableDeclarator : VariableDeclaratorId
{
  $$ = $1;
}
| VariableDeclaratorId ASSIGN VariableInitializer
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "VariableDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


VariableDeclaratorId : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "VariableDeclaratorId_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "VariableDeclaratorId_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


VariableInitializer : Expression
{
  $$ = $1;
}
| ArrayInitializer
{
  $$ = $1;
}


MethodDeclaration : InterfaceMethodDeclaration
{
  $$ = $1;
}
| FINAL InterfaceMethodDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


MethodHeader : Type MethodDeclarator
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| Type MethodDeclarator Throws
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| TypeParameters Type MethodDeclarator
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| TypeParameters Type MethodDeclarator Throws
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| VOID MethodDeclarator
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| VOID MethodDeclarator Throws
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| TypeParameters VOID MethodDeclarator
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| TypeParameters VOID MethodDeclarator Throws
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodHeader_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


MethodDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


FormalParameterList : ReceiverParameter
{
  $$ = $1;
}
| FormalParameters COMMA LastFormalParameter
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FormalParameterList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| LastFormalParameter
{
  $$ = $1;
}


FormalParameters : FormalParameters COMMA FormalParameter
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FormalParameters_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| FormalParameter
{
  $$ = $1;
}
| ReceiverParameter
{
  $$ = $1;
}


FormalParameter : FINAL Type VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| Type VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


LastFormalParameter : FINAL Type TRIPLE_DOT VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LastFormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| Type TRIPLE_DOT VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LastFormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| FormalParameter
{
  $$ = $1;
}


ReceiverParameter : Type THIS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ReceiverParameter_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Type IDENTIFIER DOT THIS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ReceiverParameter_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


Throws : THROWS ExceptionTypeList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Throws_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


ExceptionTypeList : ExceptionTypeList COMMA ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExceptionTypeList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ClassType
{
  $$ = $1;
}


MethodBody : Block
{
  $$ = $1;
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConstructorDeclaration : ConstructorModifier Throws ConstructorBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ConstructorModifier ConstructorBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


ConstructorModifier : PUBLIC ConstructorModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED ConstructorModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE ConstructorModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ConstructorDeclarator
{
  $$ = $1;
}


ConstructorDeclarator : TypeParameters IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| TypeParameters IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorDeclarator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConstructorBody : LEFT_CURLY ExplicitConstructorInvocation BlockStatements RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY BlockStatements RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY ExplicitConstructorInvocation RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstructorBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ExplicitConstructorInvocation : THIS LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| THIS LEFT_PAREN RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Primary DOT SUPER LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Primary DOT SUPER LEFT_PAREN RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExplicitConstructorInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassModifier_enum : PUBLIC ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ABSTRACT ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| FINAL ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STRICTFP ClassModifier_enum
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ENUM
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassModifier_enum_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


EnumDeclaration : ClassModifier_enum IDENTIFIER Superinterfaces EnumBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| ClassModifier_enum IDENTIFIER EnumBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


EnumBody : LEFT_CURLY EnumConstantList COMMA EnumBodyDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY COMMA EnumBodyDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY EnumConstantList EnumBodyDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY EnumConstantList COMMA RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY EnumConstantList RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY COMMA RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY EnumBodyDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


EnumConstantList : EnumConstantList COMMA EnumConstant
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstantList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| EnumConstant
{
  $$ = $1;
}


EnumConstant : IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumConstant_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


EnumBodyDeclaration : SEMI_COLON ClassBodyDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnumBodyDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


InterfaceDeclaration : InterfaceModifier IDENTIFIER TypeParameters ExtendsInterfaces InterfaceBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| InterfaceModifier IDENTIFIER ExtendsInterfaces InterfaceBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| InterfaceModifier IDENTIFIER TypeParameters InterfaceBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| InterfaceModifier IDENTIFIER InterfaceBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


InterfaceModifier : PUBLIC InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ABSTRACT InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STRICTFP InterfaceModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| INTERFACE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ExtendsInterfaces : EXTENDS InterfaceTypeList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExtendsInterfaces_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


InterfaceBody : LEFT_CURLY InterfaceMemberDeclaration RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceBody_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


InterfaceMemberDeclaration : ConstantDeclaration
{
  $$ = $1;
}
| InterfaceMethodDeclaration
{
  $$ = $1;
}
| ClassDeclaration
{
  $$ = $1;
}
| InterfaceDeclaration
{
  $$ = $1;
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| InterfaceMemberDeclaration ConstantDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| InterfaceMemberDeclaration InterfaceMethodDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| InterfaceMemberDeclaration ClassDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| InterfaceMemberDeclaration InterfaceDeclaration
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| InterfaceMemberDeclaration SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMemberDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConstantDeclaration : ConstantModifier SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstantDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConstantModifier : PUBLIC ConstantModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstantModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC ConstantModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstantModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| FINAL ConstantModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstantModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| Type VariableDeclaratorList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConstantModifier_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


InterfaceMethodModifier : PUBLIC InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PROTECTED InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| PRIVATE InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| ABSTRACT InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STATIC InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| STRICTFP InterfaceMethodModifier
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodModifier_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| MethodHeader
{
  $$ = $1;
}


InterfaceMethodDeclaration : InterfaceMethodModifier MethodBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| AT_RATE InterfaceMethodModifier MethodBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InterfaceMethodDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);

}


ArrayInitializer : LEFT_CURLY VariableInitializerList COMMA RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayInitializer_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY COMMA RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayInitializer_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY VariableInitializerList RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayInitializer_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayInitializer_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


VariableInitializerList : VariableInitializerList COMMA VariableInitializer
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "VariableInitializerList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| VariableInitializer
{
  $$ = $1;
}


Block : LEFT_CURLY BlockStatements RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Block_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Block_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


BlockStatements : BlockStatements BlockStatement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BlockStatements_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| BlockStatement
{
  $$ = $1;
}


BlockStatement : LocalVariableDeclarationStatement
{
  $$ = $1;
}
| ClassDeclaration
{
  $$ = $1;
}
| Statement
{
  $$ = $1;
}


LocalVariableDeclarationStatement : LocalVariableDeclaration SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LocalVariableDeclarationStatement_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


LocalVariableDeclaration : FINAL Type VariableDeclaratorList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LocalVariableDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| Type VariableDeclaratorList
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LocalVariableDeclaration_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


Statement : StatementWithoutTrailingSubstatement
{
  $$ = $1;
}
| LabeledStatement
{
  $$ = $1;
}
| IfThenStatement
{
  $$ = $1;
}
| IfThenElseStatement
{
  $$ = $1;
}
| WhileStatement
{
  $$ = $1;
}
| ForStatement
{
  $$ = $1;
}


StatementNoShortIf : StatementWithoutTrailingSubstatement
{
  $$ = $1;
}
| LabeledStatementNoShortIf
{
  $$ = $1;
}
| IfThenElseStatementNoShortIf
{
  $$ = $1;
}
| WhileStatementNoShortIf
{
  $$ = $1;
}
| ForStatementNoShortIf
{
  $$ = $1;
}


StatementWithoutTrailingSubstatement : Block
{
  $$ = $1;
}
| SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "StatementWithoutTrailingSubstatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ExpressionStatement
{
  $$ = $1;
}
| AssertStatement
{
  $$ = $1;
}
| SwitchStatement
{
  $$ = $1;
}
| DoStatement
{
  $$ = $1;
}
| BreakStatement
{
  $$ = $1;
}
| ContinueStatement
{
  $$ = $1;
}
| ReturnStatement
{
  $$ = $1;
}
| SynchronizedStatement
{
  $$ = $1;
}
| ThrowStatement
{
  $$ = $1;
}
| TryStatement
{
  $$ = $1;
}


LabeledStatement : IDENTIFIER COLON Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LabeledStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


LabeledStatementNoShortIf : IDENTIFIER COLON StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LabeledStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ExpressionStatement : StatementExpression SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExpressionStatement_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}



StatementExpression : Assignment
{
  $$ = $1;
}
| PreIncrementExpression
{
  $$ = $1;
}
| PreDecrementExpression
{
  $$ = $1;
}
| PostIncrementExpression
{
  $$ = $1;
}
| PostDecrementExpression
{
  $$ = $1;
}
| MethodInvocation
{
  $$ = $1;
}
| ClassInstanceCreationExpression
{
  $$ = $1;
}


IfThenStatement : IF LEFT_PAREN Expression RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "IfThenStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


IfThenElseStatement : IF LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf ELSE Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "IfThenElseStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}


IfThenElseStatementNoShortIf : IF LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf ELSE StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "IfThenElseStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}


AssertStatement : ASSERT Expression SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssertStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ASSERT Expression COLON Expression SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssertStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


SwitchStatement : SWITCH LEFT_PAREN Expression RIGHT_PAREN SwitchBlock
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


SwitchBlock : LEFT_CURLY SwitchBlockStatementGroup SwitchLabels RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlock_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY SwitchLabels RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlock_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY SwitchBlockStatementGroup RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlock_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_CURLY RIGHT_CURLY
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlock_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


SwitchBlockStatementGroup : SwitchBlockStatementGroup SwitchLabels BlockStatements
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlockStatementGroup_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| SwitchLabels BlockStatements
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchBlockStatementGroup_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


SwitchLabels : SwitchLabels SwitchLabel
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchLabels_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| SwitchLabel
{
  $$ = $1;
}


SwitchLabel : CASE ConstantExpression COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchLabel_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| DEFAULT COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SwitchLabel_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


WhileStatement : WHILE LEFT_PAREN Expression RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "WhileStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


WhileStatementNoShortIf : WHILE LEFT_PAREN Expression RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "WhileStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


DoStatement : DO Statement WHILE LEFT_PAREN Expression RIGHT_PAREN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "DoStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ForStatement : BasicForStatement
{
  $$ = $1;
}
| EnhancedForStatement
{
  $$ = $1;
}


ForStatementNoShortIf : BasicForStatementNoShortIf
{
  $$ = $1;
}
| EnhancedForStatementNoShortIf
{
  $$ = $1;
}


BasicForStatement : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $8);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $9);
}
| FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON SEMI_COLON RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
}


BasicForStatementNoShortIf : FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $8);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $9);
}
| FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON Expression SEMI_COLON RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}
| FOR LEFT_PAREN ForInit SEMI_COLON SEMI_COLON RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON Expression SEMI_COLON RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON SEMI_COLON ForUpdate RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
}
| FOR LEFT_PAREN SEMI_COLON SEMI_COLON RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BasicForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
}


ForInit : StatementExpressionList
{
  $$ = $1;
}
| LocalVariableDeclaration
{
  $$ = $1;
}


ForUpdate : StatementExpressionList
{
  $$ = $1;
}


StatementExpressionList : StatementExpressionList COMMA StatementExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "StatementExpressionList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| StatementExpression
{
  $$ = $1;
}


EnhancedForStatement : FOR LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnhancedForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $8);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $9);
}
| FOR LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnhancedForStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}


EnhancedForStatementNoShortIf : FOR LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnhancedForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $7);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $8);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $9);
}
| FOR LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EnhancedForStatementNoShortIf_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $8);
}


BreakStatement : BREAK IDENTIFIER SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BreakStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| BREAK SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "BreakStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ContinueStatement : CONTINUE IDENTIFIER SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ContinueStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| CONTINUE SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ContinueStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ReturnStatement : RETURN Expression SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ReturnStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| RETURN SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ReturnStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ThrowStatement : THROW Expression SEMI_COLON
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ThrowStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


SynchronizedStatement : SYNCHRONIZED LEFT_PAREN Expression RIGHT_PAREN Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "SynchronizedStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


TryStatement : TRY Block Catches
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| TRY Block Catches Finally
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| TRY Block Finally
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| TryWithResourcesStatement
{
  $$ = $1;
}


Catches : Catches CatchClause
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Catches_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| CatchClause
{
  $$ = $1;
}


CatchClause : CATCH LEFT_PAREN CatchFormalParameter RIGHT_PAREN Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CatchClause_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


CatchFormalParameter : FINAL CatchType VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CatchFormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| CatchType VariableDeclaratorId
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CatchFormalParameter_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


CatchType : CatchType LOR ClassType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "CatchType_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ClassType
{
  $$ = $1;
}


Finally : FINALLY Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Finally_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


TryWithResourcesStatement : TRY ResourcesSpecification Block Catches Finally
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryWithResourcesStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| TRY ResourcesSpecification Block Finally
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryWithResourcesStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| TRY ResourcesSpecification Block Catches
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryWithResourcesStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| TRY ResourcesSpecification Block
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "TryWithResourcesStatement_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ResourcesSpecification : LEFT_PAREN ResourceList SEMI_COLON RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ResourcesSpecification_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_PAREN ResourceList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ResourcesSpecification_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ResourceList : ResourceList SEMI_COLON Resource
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ResourceList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| Resource
{
  $$ = $1;
}


Resource : FINAL Type VariableDeclaratorId ASSIGN Expression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Resource_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| Type VariableDeclaratorId ASSIGN Expression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Resource_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
}



Primary : PrimaryNoNewArray
{
  $$ = $1;
}
| ArrayCreationExpression
{
  $$ = $1;
}


PrimaryNoNewArray : Literal
{
  $$ = $1;
}
| ClassLiteral
{
  $$ = $1;
}
| THIS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PrimaryNoNewArray_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 THIS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PrimaryNoNewArray_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_PAREN Expression RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PrimaryNoNewArray_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ClassInstanceCreationExpression
{
  $$ = $1;
}
| FieldAccess
{
  $$ = $1;
}
| ArrayAccess
{
  $$ = $1;
}
| MethodInvocation
{
  $$ = $1;
}
| MethodReference
{
  $$ = $1;
}


ClassLiteral : ClassType Dims DOT CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassLiteral_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| PrimitiveType Dims DOT CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassLiteral_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassLiteral_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| PrimitiveType DOT CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassLiteral_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| VOID DOT CLASS
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassLiteral_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


Literal : INTEGER_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"LITERAL( %ld )\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| FLOATING_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"LITERAL( %lf )\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| BOOLEAN_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"LITERAL( %d )\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| CHAR_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"LITERAL( %c )\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| STRING_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"LITERAL( %s )\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| NULL_LIT
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Literal_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassInstanceCreationExpression : UnqualifiedClassInstanceCreationExpression
{
  $$ = $1;
}
| temporary0 UnqualifiedClassInstanceCreationExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| Primary DOT UnqualifiedClassInstanceCreationExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnqualifiedClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
}
| NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnqualifiedClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN ClassBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnqualifiedClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnqualifiedClassInstanceCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ClassOrInterfaceTypeToInstantiate : TypeName
{
  $$ = $1;
}



FieldAccess : Primary DOT IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldAccess_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER DOT IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldAccess_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER DOT IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "FieldAccess_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ArrayAccess : ClassType LEFT_SQUARE Expression RIGHT_SQUARE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayAccess_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| PrimaryNoNewArray LEFT_SQUARE Expression RIGHT_SQUARE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayAccess_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


MethodInvocation : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Primary DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Primary DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $6);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $7);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodInvocation_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $5);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $6);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ArgumentList : ArgumentList COMMA Expression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArgumentList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| Expression
{
  $$ = $1;
}


MethodReference : ReferenceType DOUBLE_COLON IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodReference_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| Primary DOUBLE_COLON IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodReference_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUPER DOUBLE_COLON IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodReference_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| temporary0 SUPER DOUBLE_COLON IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodReference_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ReferenceType DOUBLE_COLON NEW
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MethodReference_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ArrayCreationExpression : NEW PrimitiveType DimExprs Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| NEW PrimitiveType DimExprs
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| NEW ClassType DimExprs Dims
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| NEW ClassType DimExprs
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| NEW PrimitiveType Dims ArrayInitializer
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}
| NEW ClassType Dims ArrayInitializer
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ArrayCreationExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "%s -> %s\n", $$, $4);
}


DimExprs : DimExprs DimExpr
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "DimExprs_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| DimExpr
{
  $$ = $1;
}


DimExpr : LEFT_SQUARE Expression RIGHT_SQUARE
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "DimExpr_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


Expression : AssignmentExpression
{
  $$ = $1;
}
| LambdaExpression
{
  $$ = $1;
}


LambdaExpression : LambdaParameters LambdaBody
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LambdaExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


LambdaParameters : IDENTIFIER POINTER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LambdaParameters_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_PAREN FormalParameterList RPOINTER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LambdaParameters_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_PAREN IDENTIFIER InferredFormalParameterList RPOINTER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LambdaParameters_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LEFT_PAREN IDENTIFIER RPOINTER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "LambdaParameters_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


InferredFormalParameterList : InferredFormalParameterList COMMA IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InferredFormalParameterList_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| COMMA IDENTIFIER
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InferredFormalParameterList_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


LambdaBody : Expression
{
  $$ = $1;
}
| Block
{
  $$ = $1;
}


AssignmentExpression : ConditionalExpression
{
  $$ = $1;
}
| Assignment
{
  $$ = $1;
}


Assignment : LeftHandSide AssignmentOperator Expression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "Assignment_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


LeftHandSide : ClassType
{
  $$ = $1;
}
| FieldAccess
{
  $$ = $1;
}
| ArrayAccess
{
  $$ = $1;
}


AssignmentOperator : ASSIGN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| MULASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| DIVASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| MODASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ADDASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| SUBASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| LSHIFTASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| RSHIFTASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| RRSHIFTASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ANDASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| XORASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}
| ORASSN
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AssignmentOperator_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConditionalExpression : ConditionalOrExpression
{
  $$ = $1;
}
| ConditionalOrExpression TERNARY Expression COLON ConditionalExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConditionalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}
| ConditionalOrExpression TERNARY Expression COLON LambdaExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConditionalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $4);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $5);
}


ConditionalOrExpression : ConditionalAndExpression
{
  $$ = $1;
}
| ConditionalOrExpression BOR ConditionalAndExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConditionalOrExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ConditionalAndExpression : InclusiveOrExpression
{
  $$ = $1;
}
| ConditionalAndExpression BAND InclusiveOrExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ConditionalAndExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


InclusiveOrExpression : ExclusiveOrExpression
{
  $$ = $1;
}
| InclusiveOrExpression LOR ExclusiveOrExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "InclusiveOrExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ExclusiveOrExpression : AndExpression
{
  $$ = $1;
}
| ExclusiveOrExpression LXOR AndExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ExclusiveOrExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


AndExpression : EqualityExpression
{
  $$ = $1;
}
| AndExpression LAND EqualityExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AndExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


EqualityExpression : RelationalExpression
{
  $$ = $1;
}
| EqualityExpression EQUAL RelationalExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EqualityExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| EqualityExpression NOTEQ RelationalExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "EqualityExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


RelationalExpression : ShiftExpression
{
  $$ = $1;
}
| RelationalExpression LT ShiftExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "RelationalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| RelationalExpression GT ShiftExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "RelationalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| RelationalExpression LTE ShiftExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "RelationalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| RelationalExpression GTE ShiftExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "RelationalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| RelationalExpression INSTANCEOF ReferenceType
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "RelationalExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


ShiftExpression : AdditiveExpression
{
  $$ = $1;
}
| ShiftExpression LSHIFT AdditiveExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ShiftExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ShiftExpression RSHIFT AdditiveExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ShiftExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| ShiftExpression RRSHIFT AdditiveExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "ShiftExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


AdditiveExpression : MultiplicativeExpression
{
  $$ = $1;
}
| AdditiveExpression ADD MultiplicativeExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AdditiveExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| AdditiveExpression SUB MultiplicativeExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "AdditiveExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


MultiplicativeExpression : UnaryExpression
{
  $$ = $1;
}
| MultiplicativeExpression MUL UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MultiplicativeExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| MultiplicativeExpression DIV UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MultiplicativeExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}
| MultiplicativeExpression MOD UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "MultiplicativeExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $3);
}


UnaryExpression : PreIncrementExpression
{
  $$ = $1;
}
| PreDecrementExpression
{
  $$ = $1;
}
| ADD UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnaryExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| SUB UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnaryExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| UnaryExpressionNotPlusMinus
{
  $$ = $1;
}


PreIncrementExpression : INC UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PreIncrementExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


PreDecrementExpression : DEC UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PreDecrementExpression_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}


UnaryExpressionNotPlusMinus : PostfixExpression
{
  $$ = $1;
}
| NEG UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnaryExpressionNotPlusMinus_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| NOT UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnaryExpressionNotPlusMinus_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
}
| LEFT_PAREN PrimitiveType RIGHT_PAREN UnaryExpression
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "UnaryExpressionNotPlusMinus_%ld", counter);
  counter++;
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $1);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $2);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $3);
  fprintf(outfile, "%s -> label_%ld\n", $$, label_counter);
  label_counter++;
  fprintf(outfile, "%s -> %s\n", $$, $4);
}


PostfixExpression : Primary
{
  $$ = $1;
}
| PostFixType
{
  $$ = $1;
}
| PostIncrementExpression
{
  $$ = $1;
}
| PostDecrementExpression
{
  $$ = $1;
}


PostIncrementExpression : PostfixExpression INC
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PostIncrementExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


PostDecrementExpression : PostfixExpression DEC
{
  $$ = (char*)malloc(64);
  snprintf($$, 64, "PostDecrementExpression_%ld", counter);
  counter++;
  fprintf(outfile, "%s -> %s\n", $$, $1);
  fprintf(outfile, "label_%ld [label = \"%s\"]\n", label_counter, $2);
  fprintf(outfile, " %s -> label_%ld\n", $$, label_counter);
  label_counter++;
}


ConstantExpression : Expression
{
  $$ = $1;
}


%%
int main(int argc, char** argv)
{
  int help_message = 0;

  static struct option long_options[] =
    {
      {"inp",     required_argument, 0, 'i'},
      {"out",      required_argument, 0, 'o'},
      {"help", no_argument, &help_message, 1},
      {0, 0, 0, 0}
    };

  char* output = NULL;
  int c;
  int opt_index = 1;
  outfile = stdout;
  while (1)
  {
    c = getopt_long (argc, argv, "i:o:",long_options, &opt_index);
    if (c == -1)
      break;

    switch (c)
    {
      case 0:
        break;
      case 'i':
        yyin = fopen(optarg,"r");
        break;
      case 'o':
        output = (char*)malloc(strlen(optarg)+1);
        strncpy(output, optarg, strlen(optarg)+1);
        output[strlen(optarg)] = '\0';
        outfile = fopen(output, "w");
        break;
    }
  }
  if(help_message)
  {
    printf("USAGE: %s --inp <Input_File> --out <Output_File> --help\n", argv[0]);
    printf("Default Input File is stdin\n");
    printf("Default Output File is stdout\n");
    exit(-1);
  }
  fprintf(outfile, "digraph program {\n");
  fprintf(outfile, "ordering=out\n");
  yyparse();
  fprintf(outfile,"}\n");
  return 1;
}
