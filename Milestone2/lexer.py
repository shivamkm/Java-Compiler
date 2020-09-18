import ply.lex as lex
import sys
import re
from ply.lex import TOKEN

java_keywords = [ 'abstract', 'continue', 'for', 'new', 'switch',
'assert',     'default',    'if',           'package',     'synchronized',
'boolean',   'do',         'goto',         'private',     'this',
'break',      'double',     'implements',   'protected',   'throw',
'byte',       'else',       'import',       'public',      'throws',
'case',       'enum',       'instanceof',   'return',      'transient',
'catch',      'extends',    'int',          'short',       'try',
'char',       'final',      'interface',    'static',      'void',
'class',      'finally',    'long',         'strictfp',    'volatile',
'const',      'float',      'native',       'super',       'while' ]

tokens = [ 'IDENTIFIER',
'LEFT_PAREN',
'RIGHT_PAREN',
'LEFT_CURLY',
'RIGHT_CURLY',
'LEFT_SQUARE',
'RIGHT_SQUARE',
'SEMI_COLON',
'COMMA',
'DOT',
'TRIPLE_DOT',
'AT_RATE',
'DOUBLE_COLON',
'ASSIGN',
'GT',
'LT',
'NOT',
'NEG',
'TERNARY',
'COLON',
'POINTER',
'RPOINTER',
'EQUAL',
'GTE',
'LTE',
'NOTEQ',
'BAND',
'BOR',
'INC',
'DEC',
'ADD',
'SUB',
'MUL',
'DIV',
'LAND',
'LOR',
'LXOR',
'MOD',
'LSHIFT',
'RSHIFT',
'RRSHIFT',
'ADDASSN',
'SUBASSN',
'MULASSN',
'DIVASSN',
'ANDASSN',
'ORASSN',
'XORASSN',
'MODASSN',
'LSHIFTASSN',
'RSHIFTASSN',
'RRSHIFTASSN',
'BOOLEAN_LIT',
'CHAR_LIT',
'NULL_LIT',
'STRING_LIT',
'INTEGER_LIT',
'FLOATING_LIT',
'ABSTRACT',
'CONTINUE',
'FOR',
'NEW',
'SWITCH',
'ASSERT',
'DEFAULT',
'IF',
'PACKAGE',
'SYNCHRONIZED',
'BOOLEAN',
'DO',
'GOTO',
'PRIVATE',
'THIS',
'BREAK',
'DOUBLE',
'IMPLEMENTS',
'PROTECTED',
'THROW',
'BYTE',
'ELSE',
'IMPORT',
'PUBLIC',
'THROWS',
'CASE',
'ENUM',
'INSTANCEOF',
'RETURN',
'TRANSIENT',
'CATCH',
'EXTENDS',
'INT',
'SHORT',
'TRY',
'CHAR',
'FINAL',
'INTERFACE',
'STATIC',
'VOID',
'CLASS',
'FINALLY',
'LONG',
'STRICTFP',
'VOLATILE',
'CONST',
'FLOAT',
'NATIVE',
'SUPER',
'WHILE' ]

t_ignore = ' \t\f'
t_ignore_SINGLE_COMMENT = r'//.*'

def t_MULT_COMMENT(t):
    r'/\*([^*]|[*]+[^*/])*[*]+/'
    t.lexer.lineno += t.value.count('\n')

def t_NEWLINE(t):
	r'\n'
	t.lexer.lineno += 1

def t_BOOLEAN_LIT(t):
	r'true|false'
	return t

def t_error(t):
	print("Illegal character '{}' in line {}".format(t.value[0], t.lexer.lineno))
	sys.exit(-1)

def t_NULL_LIT(t):
	r'null'
	return t

def t_IDENTIFIER(t):
    r'[A-Za-z_$][A-Za-z0-9_$]*'
    if t.value in java_keywords:
        t.type = t.value.upper()
        if t.value == 'enum':
        	print("Enums not supported!")
        	sys.exit(-1)
        if t.value == 'super':
        	print("Super keyword not supported!")
        	sys.exit(-1)
    return t

t_BOR = r'\|\|'
t_BAND = r'&&'
t_EQUAL = r'=='
t_NOTEQ = r'!='
t_GTE = r'>='
t_LTE = r'<='
t_LSHIFT = r'<<'
t_RSHIFT = r'>>'
t_RRSHIFT = r'>>>'
t_DOUBLE_COLON = r'::'
t_POINTER = r'->'
t_RPOINTER = r'\)[ \t\f\n]*->'
t_MULASSN = r'\*='
t_DIVASSN = r'/='
t_MODASSN = r'%='
t_ADDASSN = r'\+='
t_SUBASSN = r'-='
t_LSHIFTASSN = r'<<='
t_RSHIFTASSN = r'>>='
t_RRSHIFTASSN = r'>>>='
t_ANDASSN = r'&='
t_ORASSN = r'\|='
t_XORASSN = r'\^='
t_INC = r'\+\+'
t_DEC = r'\-\-'
t_TRIPLE_DOT = r'\.\.\.'
t_LEFT_PAREN = r'\('
t_RIGHT_PAREN = r'\)'
t_ADD = r'\+'
t_SUB = r'-'
t_MUL = r'\*'
t_DIV = r'/'
t_ASSIGN = r'='
t_TERNARY = r'\?'
t_COLON = r':'
t_COMMA = r','
t_DOT = r'\.'
t_LXOR = r'\^'
t_LOR = r'\|'
t_LAND = r'&'
t_NEG = r'~'
t_NOT = r'!'
t_LEFT_SQUARE = r'\['
t_RIGHT_SQUARE = r']'
t_LEFT_CURLY = r'{'
t_RIGHT_CURLY = r'}'
t_SEMI_COLON = r';'
t_LT = r'<'
t_GT = r'>'
t_AT_RATE = r'@[ ]*Override'
t_MOD = r'%'


t_CHAR_LIT = r'\'([^\r\n\'\\]|\\b|\\t|\\n|\\f|\\r|\\|\\\"|\\\'|(\\[0-7]|\\[0-7][0-7]|\\[0-3][0-7][0-7]))\''
t_STRING_LIT = r'\"([^\r\n\"\\]|\\b|\\t|\\n|\\f|\\r|\\|\\\"|\\\'|(\\[0-7]|\\[0-7][0-7]|\\[0-3][0-7][0-7]))*\"'

hexnumeral = r'0[xX][0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?[lL]?'
binarynumeral = r'0[bB][01]([01_]*[01])?[lL]?'
octnumeral = r'0[_]*[0-7]([0-7_]*[0-7])?[lL]?'
decimel = r'[1-9][_]*[0-9][0-9_]*[0-9][lL]? | [1-9][_]*[0-9][lL]? | [0-9][lL]?'
t_INTEGER_LIT = hexnumeral + r'|' + binarynumeral + r'|' + octnumeral + r'|' + decimel

digits = r'[0-9]([0-9_]*[0-9])?'
exponentpart = r'[eE][+-]?' + digits
t1 = digits + r'\.(' + digits + r')?(' + exponentpart + r')?[fFdD]?'
t2 = r'\.' + digits + r'(' + exponentpart + r')?[fFdD]?'
t3 = digits + exponentpart + r'[fFdD]?'
t4 = digits + r'(' + exponentpart + r')?' + r'[fFdD]'
decimel_float = t1 + r'|' + t2 + r'|' + t3 + r'|' + t4

hexdigits = r'[0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])?'
h1 = hexnumeral + r'\.'
h2 = r'0[xX](' + hexdigits + r')?\.' + hexdigits
hexsignificand = r'(' + h1 + r'|' + h2 + r')'
hexfloat = hexsignificand + r'[pP][+-]?' + digits + r'[fFdD]?'

t_FLOATING_LIT = decimel_float + r'|' + hexfloat

if __name__ == '__main__':
	lexer = lex.lex()
	file = open(sys.argv[1],'r')
	data = file.read()
	lexer.input(data)
	file.close()
	token_dict = dict()
	for i in lexer:
		print(i.value)
		if i.value in token_dict:
			token_dict[i.value][1] = token_dict[i.value][1] + 1
		else:
			token_dict[i.value] = [i.type, 1]

	# for key in token_dict:
	# 	print("%-20s, %-20s, %-5d" % (key, token_dict[key][0], token_dict[key][1]))

