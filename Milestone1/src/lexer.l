%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <getopt.h>
#include "parser.tab.h"

using namespace std;

void error_lexer();


typedef struct
{
  char* name;
  int count;
}token_struct;

vector<token_struct> tokens_found;
int line_num;

%}

%x single_begin
%x multi_begin
%x char_start
%x char_to_end

input_character [^\r\n]
single_char [^\r\n'\\]
octalescape ("\\"[0-7]|"\\"[0-7][0-7]|"\\"[0-3][0-7][0-7])
escapeseq ("\\b"|"\\t"|"\\n"|"\\f"|"\\r"|"\\\""|"\\'"|"\\"|{octalescape})
character_lit ({single_char}|{escapeseq})

sttring_inp ([^\r\n"\\]|{escapeseq})

integer_suffix [lL]
underscore [_]
non_zero_digit [1-9]
digit [0-9]
digit_underscore ({digit}|{underscore})
digits {non_zero_digit}{digit_underscore}*{digit}
new_digits {digit}|{digit}{digit_underscore}*{digit}
decimel ("0"|{non_zero_digit}{new_digits}?|{non_zero_digit}"_"{new_digits}){integer_suffix}?

hexdigit [0-9a-fA-F]
hexdigit_underscore ({hexdigit}|{underscore})
hexdigits {hexdigit}{hexdigit_underscore}*{hexdigit}|{hexdigit}
hexnumber ("0x"|"0X"){hexdigits}{integer_suffix}?

bindigit [0-1]
bindigit_underscore ({bindigit}|{underscore})
bindigits {bindigit}{bindigit_underscore}*{bindigit}|{bindigit}
binnumber ("0b"|"0B"){bindigits}{integer_suffix}?

octal [0-7]
octal_underscore ({octal}|{underscore})
octdigits {octal}{octal_underscore}*{octal}|{octal}
octnumber "0"({octdigits}|[_]*{octdigits}){integer_suffix}?

integer_lit ({decimel}|{hexnumber}|{binnumber}|{octnumber})

float_suffix [fFdD]
exponent [eE][+-]?{decimel}

decimel_float "Float.NaN"|"Double.NaN"|({new_digits}"."{new_digits}?{exponent}?{float_suffix}?)|("."{new_digits}{exponent}?{float_suffix}?)|({new_digits}{exponent}{float_suffix}?)|({new_digits}{exponent}?{float_suffix})

signed_int [+-]?{decimel}
bin_exp_ind [pP]
bin_exp {bin_exp_ind}{signed_int}
hexsignificand ({hexnumber}["."]?)|(("0x"|"0X"){hexdigits}?"."{hexdigits})
hex_float {hexsignificand}{bin_exp}{float_suffix}?


java_letter [a-zA-Z$_]
java_letter_or_digit [a-zA-Z0-9$_]
identifier {java_letter}{java_letter_or_digit}*

separator "("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::"
opearator "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="

boolean_lit true|false

%%
"//" BEGIN(single_begin);
"/*" BEGIN(multi_begin);
<single_begin>"\n" { line_num++; BEGIN(INITIAL); }
<multi_begin>"\n" { line_num++; }
<multi_begin>"*/" { BEGIN(INITIAL); }

" " { }
"\t" { }
"\f" { }
"\n" { line_num++; }

abstract { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(abstract)", 32); /* printf("TOKEN: %s\n",yytext); */ return ABSTRACT; }
continue { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(continue)", 32); /* printf("TOKEN: %s\n",yytext); */ return CONTINUE; }
for { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(for)", 32); /* printf("TOKEN: %s\n",yytext); */ return FOR; }
new { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(new)", 32); /* printf("TOKEN: %s\n",yytext); */ return NEW; }
switch { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(switch)", 32); /* printf("TOKEN: %s\n",yytext); */ return SWITCH; }
assert { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(assert)", 32); /* printf("TOKEN: %s\n",yytext); */ return ASSERT; }
default { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(default)", 32); /* printf("TOKEN: %s\n",yytext); */ return DEFAULT; }
if { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(if)", 32); /* printf("TOKEN: %s\n",yytext); */ return IF; }
package { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(package)", 32); /* printf("TOKEN: %s\n",yytext); */ return PACKAGE; }
synchronized { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(synchronized)", 32); /* printf("TOKEN: %s\n",yytext); */ return SYNCHRONIZED; }
boolean { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(boolean)", 32); /* printf("TOKEN: %s\n",yytext); */ return BOOLEAN; }
do { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(do)", 32); /* printf("TOKEN: %s\n",yytext); */ return DO; }
goto { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(goto)", 32); /* printf("TOKEN: %s\n",yytext); */ return GOTO; }
private { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(private)", 32); /* printf("TOKEN: %s\n",yytext); */ return PRIVATE; }
this { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(this)", 32); /* printf("TOKEN: %s\n",yytext); */ return THIS; }
break { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(break)", 32); /* printf("TOKEN: %s\n",yytext); */ return BREAK; }
double { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(double)", 32); /* printf("TOKEN: %s\n",yytext); */ return DOUBLE; }
implements { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(implements)", 32); /* printf("TOKEN: %s\n",yytext); */ return IMPLEMENTS; }
protected { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(protected)", 32); /* printf("TOKEN: %s\n",yytext); */ return PROTECTED; }
throw { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(throw)", 32); /* printf("TOKEN: %s\n",yytext); */ return THROW; }
byte { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(byte)", 32); /* printf("TOKEN: %s\n",yytext); */ return BYTE; }
else { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(else)", 32); /* printf("TOKEN: %s\n",yytext); */ return ELSE; }
import { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(import)", 32); /* printf("TOKEN: %s\n",yytext); */ return IMPORT; }
public { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(public)", 32); /* printf("TOKEN: %s\n",yytext); */ return PUBLIC; }
throws { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(throws)", 32); /* printf("TOKEN: %s\n",yytext); */ return THROWS; }
case { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(case)", 32); /* printf("TOKEN: %s\n",yytext); */ return CASE; }
enum { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(enum)", 32); /* printf("TOKEN: %s\n",yytext); */ return ENUM; }
instanceof { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(instanceof)", 32); /* printf("TOKEN: %s\n",yytext); */ return INSTANCEOF; }
return { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(return)", 32); /* printf("TOKEN: %s\n",yytext); */ return RETURN; }
transient { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(transient)", 32); /* printf("TOKEN: %s\n",yytext); */ return TRANSIENT; }
catch { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(catch)", 32); /* printf("TOKEN: %s\n",yytext); */ return CATCH; }
extends { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(extends)", 32); /* printf("TOKEN: %s\n",yytext); */ return EXTENDS; }
int { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(int)", 32); /* printf("TOKEN: %s\n",yytext); */ return INT; }
short { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(short)", 32); /* printf("TOKEN: %s\n",yytext); */ return SHORT; }
try { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(try)", 32); /* printf("TOKEN: %s\n",yytext); */ return TRY; }
char { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(char)", 32); /* printf("TOKEN: %s\n",yytext); */ return CHAR; }
final { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(final)", 32); /* printf("TOKEN: %s\n",yytext); */ return FINAL; }
interface { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(interface)", 32); /* printf("TOKEN: %s\n",yytext); */ return INTERFACE; }
static { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(static)", 32); /* printf("TOKEN: %s\n",yytext); */ return STATIC; }
void { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(void)", 32); /* printf("TOKEN: %s\n",yytext); */ return VOID; }
class { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(class)", 32); /* printf("TOKEN: %s\n",yytext); */ return CLASS; }
finally { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(finally)", 32); /* printf("TOKEN: %s\n",yytext); */ return FINALLY; }
long { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(long)", 32); /* printf("TOKEN: %s\n",yytext); */ return LONG; }
strictfp { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(strictfp)", 32); /* printf("TOKEN: %s\n",yytext); */ return STRICTFP; }
volatile { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(volatile)", 32); /* printf("TOKEN: %s\n",yytext); */ return VOLATILE; }
const { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(const)", 32); /* printf("TOKEN: %s\n",yytext); */ return CONST; }
float { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(float)", 32); /* printf("TOKEN: %s\n",yytext); */ return FLOAT; }
native { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(native)", 32); /* printf("TOKEN: %s\n",yytext); */ return NATIVE; }
super { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(super)", 32); /* printf("TOKEN: %s\n",yytext); */ return SUPER; }
while { yylval.str = (char*)malloc(32); strncpy(yylval.str, "KEYWORD(while)", 32); /* printf("TOKEN: %s\n",yytext); */ return WHILE; }

"(" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( ( )", 32); /* printf("TOKEN: %s\n",yytext); */ return LEFT_PAREN; }
")" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( ) )", 32); /* printf("TOKEN: %s\n",yytext); */ return RIGHT_PAREN; }
"{" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( { )", 32); /* printf("TOKEN: %s\n",yytext); */ return LEFT_CURLY; }
"}" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( } )", 32); /* printf("TOKEN: %s\n",yytext); */ return RIGHT_CURLY; }
"[" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( [ )", 32); /* printf("TOKEN: %s\n",yytext); */ return LEFT_SQUARE; }
"]" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( ] )", 32); /* printf("TOKEN: %s\n",yytext); */ return RIGHT_SQUARE; }
";" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( ; )", 32); /* printf("TOKEN: %s\n",yytext); */ return SEMI_COLON; }
"," { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( , )", 32); /* printf("TOKEN: %s\n",yytext); */ return COMMA; }
"." { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( . )", 32); /* printf("TOKEN: %s\n",yytext); */ return DOT; }
"..." { yylval.str = (char*)malloc(24); strncpy(yylval.str, "SEPARATOR( ... )", 24); /* printf("TOKEN: %s\n",yytext); */ return TRIPLE_DOT; }
"@"[ ]*"Override" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( @ )", 32); /* printf("TOKEN: %s\n",yytext); */ return AT_RATE; }
"::" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "SEPARATOR( :: )", 32); /* printf("TOKEN: %s\n",yytext); */ return DOUBLE_COLON; }

{boolean_lit} { if(strncmp(yytext, "true", 32) == 0) { yylval.truth = true;} else { yylval.truth = false;} /* printf("TOKEN: %s\n",yytext); */ return BOOLEAN_LIT; }
[']{character_lit}['] { yylval.character = yytext[1]; /* printf("TOKEN: %s\n",yytext); */ return CHAR_LIT; }
["]{sttring_inp}*["] { yylval.str = (char*)malloc(strlen(yytext)+1); yytext[strlen(yytext)-1] = '\0'; strncpy(yylval.str, yytext+1, strlen(yytext)+1); /* printf("TOKEN: %s\n",yytext); */ return STRING_LIT; }
"null" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "null", 32); /* printf("TOKEN: %s\n",yytext); */ return NULL_LIT; }
{octnumber} { yylval.integer = strtol(yytext, NULL, 32); /* printf("TOKEN: %s\n",yytext); */ return INTEGER_LIT; }
{decimel} { yylval.integer = strtol(yytext, NULL, 10); /* printf("TOKEN: %s\n",yytext); */ return INTEGER_LIT; }
{hexnumber} { yylval.integer = strtol(yytext, NULL, 32); /* printf("TOKEN: %s\n",yytext); */ return INTEGER_LIT; }
{binnumber} { yylval.integer = strtol(yytext, NULL, 2); /* printf("TOKEN: %s\n",yytext); */ return INTEGER_LIT; }
{decimel_float} { yylval.fraction = strtod(yytext, NULL); /* printf("TOKEN: %s\n",yytext); */ return FLOATING_LIT; }
{hex_float} { yylval.fraction = strtod(yytext, NULL); /* printf("TOKEN: %s\n",yytext); */ return FLOATING_LIT; }

"=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( = )", 32); /* printf("TOKEN: %s\n",yytext); */ return ASSIGN; }
">" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( > )", 32); /* printf("TOKEN: %s\n",yytext); */ return GT; }
"<" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( < )", 32); /* printf("TOKEN: %s\n",yytext); */ return LT; }
"!" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ! )", 32); /* printf("TOKEN: %s\n",yytext); */ return NOT; }
"~" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ~ )", 32); /* printf("TOKEN: %s\n",yytext); */ return NEG; }
"?" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ? )", 32); /* printf("TOKEN: %s\n",yytext); */ return TERNARY; }
":" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( : )", 32); /* printf("TOKEN: %s\n",yytext); */ return COLON; }
"->" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( -> )", 32); /* printf("TOKEN: %s\n",yytext); */ return POINTER; }
")"[ \t\f\n]*"->" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ) -> )", 32); /* printf("TOKEN: %s\n",yytext); */ return RPOINTER; }
"==" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( == )", 32); /* printf("TOKEN: %s\n",yytext); */ return EQUAL; }
">=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( >= )", 32); /* printf("TOKEN: %s\n",yytext); */ return GTE; }
"<=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( <= )", 32); /* printf("TOKEN: %s\n",yytext); */ return LTE; }
"!=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( != )", 32); /* printf("TOKEN: %s\n",yytext); */ return NOTEQ; }
"&&" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( && )", 32); /* printf("TOKEN: %s\n",yytext); */ return BAND; }
"||" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( || )", 32); /* printf("TOKEN: %s\n",yytext); */ return BOR; }
"++" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ++ )", 32); /* printf("TOKEN: %s\n",yytext); */ return INC; }
"--" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( -- )", 32); /* printf("TOKEN: %s\n",yytext); */ return DEC; }
"+" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( + )", 32); /* printf("TOKEN: %s\n",yytext); */ return ADD; }
"-" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( - )", 32); /* printf("TOKEN: %s\n",yytext); */ return SUB; }
"*" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( * )", 32); /* printf("TOKEN: %s\n",yytext); */ return MUL; }
"/" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( / )", 32); /* printf("TOKEN: %s\n",yytext); */ return DIV; }
"&" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( & )", 32); /* printf("TOKEN: %s\n",yytext); */ return LAND; }
"|" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( | )", 32); /* printf("TOKEN: %s\n",yytext); */ return LOR; }
"^" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ^ )", 32); /* printf("TOKEN: %s\n",yytext); */ return LXOR; }
"%" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( % )", 32); /* printf("TOKEN: %s\n",yytext); */ return MOD; }
"<<" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( << )", 32); /* printf("TOKEN: %s\n",yytext); */ return LSHIFT; }
">>" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( >> )", 32); /* printf("TOKEN: %s\n",yytext); */ return RSHIFT; }
">>>" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( >>> )", 32); /* printf("TOKEN: %s\n",yytext); */ return RRSHIFT; }
"+=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( += )", 32); /* printf("TOKEN: %s\n",yytext); */ return ADDASSN; }
"-=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( -= )", 32); /* printf("TOKEN: %s\n",yytext); */ return SUBASSN; }
"*=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( *= )", 32); /* printf("TOKEN: %s\n",yytext); */ return MULASSN; }
"/=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( /= )", 32); /* printf("TOKEN: %s\n",yytext); */ return DIVASSN; }
"&=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( &= )", 32); /* printf("TOKEN: %s\n",yytext); */ return ANDASSN; }
"|=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( |= )", 32); /* printf("TOKEN: %s\n",yytext); */ return ORASSN; }
"^=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( ^= )", 32); /* printf("TOKEN: %s\n",yytext); */ return XORASSN; }
"%=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( %= )", 32); /* printf("TOKEN: %s\n",yytext); */ return MODASSN; }
"<<=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( <<= )", 32); /* printf("TOKEN: %s\n",yytext); */ return LSHIFTASSN; }
">>=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( >>= )", 32); /* printf("TOKEN: %s\n",yytext); */ return RSHIFTASSN; }
">>>=" { yylval.str = (char*)malloc(32); strncpy(yylval.str, "OPERATOR( >>>= )", 32); /* printf("TOKEN: %s\n",yytext); */ return RRSHIFTASSN; }

{identifier} { yylval.str = (char*)malloc(strlen(yytext)+32); snprintf(yylval.str, strlen(yytext)+32, "IDENTIFIER( %s )", yytext); /* printf("TOKEN: %s\n",yytext); */ return IDENTIFIER; }

. { error_lexer(); }


%%

void error_lexer()
{
  fprintf(stderr, "ERROR: Unmatched character %s at line number %d\n", yytext, line_num);
  exit(-1);
}

void debug(const char* message)
{
  return;
  int found = 0;
  int count = 0;
  for (vector<token_struct>::iterator one_token = tokens_found.begin(); one_token != tokens_found.end(); ++one_token)
  {
    if(strncmp("int",(*one_token).name,32) == 0)
    {
      count = (*one_token).count;
      found = 1;
      break;
    }
  }
  if(found)
  {
    printf("%s:  Found token: %20s at line %d. Int count: %d\n", message, yytext, line_num+1, count);
  }
  else
  {
    printf("%s:  Found token: %20s at line %d. Int not found\n", message, yytext, line_num+1);
  }
}

int is_keyword(char* token)
{
  const char* keyword_list[] = { "abstract",   "continue",   "for",          "new",         "switch",
                          "assert",     "default",    "if",           "package",     "synchronized",
                          "boolean",    "do",         "goto",         "private",     "this",
                          "break",      "double",     "implements",   "protected",   "throw",
                          "byte",       "else",       "import",       "public",      "throws",
                          "case",       "enum",       "instanceof",   "return",      "transient",
                          "catch",      "extends",    "int",          "short",       "try",
                          "char",       "final",      "interface",    "static",      "void",
                          "class",      "finally",    "long",         "strictfp",    "volatile",
                          "const",      "float",      "native",       "super",       "while"          };

  for(int i = 0; i < 50; i++)
  {
    if(!strncmp(token, keyword_list[i], strlen(token)) && strlen(token) == strlen(keyword_list[i]))
    {
      return 1;
    }
  }
  return 0;
}


int yywrap()
{
  return 1;
}
