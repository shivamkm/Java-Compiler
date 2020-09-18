/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    LEFT_PAREN = 259,
    RIGHT_PAREN = 260,
    LEFT_CURLY = 261,
    RIGHT_CURLY = 262,
    LEFT_SQUARE = 263,
    RIGHT_SQUARE = 264,
    SEMI_COLON = 265,
    COMMA = 266,
    DOT = 267,
    TRIPLE_DOT = 268,
    AT_RATE = 269,
    DOUBLE_COLON = 270,
    ASSIGN = 271,
    GT = 272,
    LT = 273,
    NOT = 274,
    NEG = 275,
    TERNARY = 276,
    COLON = 277,
    POINTER = 278,
    RPOINTER = 279,
    EQUAL = 280,
    GTE = 281,
    LTE = 282,
    NOTEQ = 283,
    BAND = 284,
    BOR = 285,
    INC = 286,
    DEC = 287,
    ADD = 288,
    SUB = 289,
    MUL = 290,
    DIV = 291,
    LAND = 292,
    LOR = 293,
    LXOR = 294,
    MOD = 295,
    LSHIFT = 296,
    RSHIFT = 297,
    RRSHIFT = 298,
    ADDASSN = 299,
    SUBASSN = 300,
    MULASSN = 301,
    DIVASSN = 302,
    ANDASSN = 303,
    ORASSN = 304,
    XORASSN = 305,
    MODASSN = 306,
    LSHIFTASSN = 307,
    RSHIFTASSN = 308,
    RRSHIFTASSN = 309,
    BOOLEAN_LIT = 310,
    CHAR_LIT = 311,
    NULL_LIT = 312,
    STRING_LIT = 313,
    INTEGER_LIT = 314,
    FLOATING_LIT = 315,
    ABSTRACT = 316,
    CONTINUE = 317,
    FOR = 318,
    NEW = 319,
    SWITCH = 320,
    ASSERT = 321,
    DEFAULT = 322,
    IF = 323,
    PACKAGE = 324,
    SYNCHRONIZED = 325,
    BOOLEAN = 326,
    DO = 327,
    GOTO = 328,
    PRIVATE = 329,
    THIS = 330,
    BREAK = 331,
    DOUBLE = 332,
    IMPLEMENTS = 333,
    PROTECTED = 334,
    THROW = 335,
    BYTE = 336,
    ELSE = 337,
    IMPORT = 338,
    PUBLIC = 339,
    THROWS = 340,
    CASE = 341,
    ENUM = 342,
    INSTANCEOF = 343,
    RETURN = 344,
    TRANSIENT = 345,
    CATCH = 346,
    EXTENDS = 347,
    INT = 348,
    SHORT = 349,
    TRY = 350,
    CHAR = 351,
    FINAL = 352,
    INTERFACE = 353,
    STATIC = 354,
    VOID = 355,
    CLASS = 356,
    FINALLY = 357,
    LONG = 358,
    STRICTFP = 359,
    VOLATILE = 360,
    CONST = 361,
    FLOAT = 362,
    NATIVE = 363,
    SUPER = 364,
    WHILE = 365
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 42 "parser.y" /* glr.c:197  */

  long int integer;
  char* str;
  double fraction;
  bool truth;
  char character;

#line 173 "parser.tab.h" /* glr.c:197  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
