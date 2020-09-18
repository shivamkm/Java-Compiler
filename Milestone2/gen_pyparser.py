temp_file = open('temp','r')

curr_symbol = ""
counter = 0

print('import ply.yacc as yacc')
print('import lexer, sys')
print('from lexer import tokens')
print('import ply.lex as lex')
print()


for line in temp_file:
	syms = line.strip().split()
	if len(syms) == 0:
		continue
	elif syms[1] == ':':
		curr_symbol = syms[0].strip()
		print("def p_"+str(counter)+"(p):")
		print("  \'"+curr_symbol+' : ',end="")
		for l in syms[2:]:
			print(l.strip()+" ",end="")
		print("\'")
		print()
		counter = counter + 1
	else:
		print("def p_"+str(counter)+"(p):")
		print("  \'"+curr_symbol+' : ',end="")
		for l in syms[1:]:
			print(l.strip()+" ",end="")
		print("\'")
		print()
		counter = counter + 1

print('def p_error(p):')
print('  print(p)')
print('  print("Syntax error in input!")')
print()
print('if __name__ == \'__main__\':')
print('  lexer = lex.lex(module = lexer)')
print('  parser = yacc.yacc(start = \'CompilationUnit\')')
print('  in_file = open(sys.argv[1], \'r\')')
print('  data = in_file.read()')
print('  in_file.close()')
print('  result = parser.parse(data)')
print('  print(result)')
