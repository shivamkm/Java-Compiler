all: lexer.l parser.y
	lex lexer.l
	bison -d parser.y
	g++ -c lex.yy.c -DECHO
	g++ -c parser.tab.c
	g++ lex.yy.o parser.tab.o -o parser

clean:
	rm lex.yy.* parser parser.tab.*
