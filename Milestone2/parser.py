import ply.yacc as yacc
import lexer, sys
from lexer import tokens
import ply.lex as lex
from symbol import symbol_table
from IR import IR

next_num = 0
gen_symbol_table = 0
type_check = 0
gen_IR = 0
curr_table = None
table_list = []
IR_list = []
counter = 0
label_counter = 0

def get_newlabel():
  global label_counter
  new_label = "%label"+str(label_counter)
  label_counter = label_counter + 1
  return new_label

def get_newvar():
  global counter
  new_var = "t_" + str(counter)
  counter = counter + 1
  return new_var


def get_primitive_type_size(t):
  if t == 'BYTE':
    return 1
  if t == 'SHORT':
    return 2;
  if t == 'INT' :
    return 4
  if t == 'LONG' :
    return 8
  if t == 'FLOAT':
    return 4
  if t == 'DOUBLE':
    return 8
  if t == 'BOOLEAN' :
    return 1
  if t == 'CHAR':
    return 1
  if t == 'CLASSREF':
    return 8

def backpatch(nextlist, nextinstr):
  for i in range(len(nextlist)):
    IR_list[nextlist[i]].source1 = str(nextinstr)

def biggest_int(t1, t2):
  if t1 == 'LONG' or t2 == 'LONG':
    return 'LONG'
  if t1 == 'INT' or t2 == 'INT':
    return 'INT'
  if t1 == 'SHORT' or t2 == 'SHORT':
    return 'SHORT'
  return 'BYTE'

def biggest_real(t1, t2):
  if t1 == 'DOUBLE' or t2 == 'DOUBLE':
    return 'DOUBLE'
  if t1 == 'FLOAT' or t2 == 'FLOAT':
    return 'FLOAT'
  if t1 == 'LONG' or t2 == 'LONG':
    return 'LONG'
  if t1 == 'INT' or t2 == 'INT':
    return 'INT'
  if t1 == 'SHORT' or t2 == 'SHORT':
    return 'SHORT'
  if t1 == 'BYTE' or t2 == 'BYTE':
    return 'BYTE'
  if t1 == 'CHAR' or t2 == 'CHAR':
    return 'CHAR'
  return 'BOOLEAN'

def p_0(p):
  'TypeName : IDENTIFIER '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_1(p):
  'TypeName : temporary0 IDENTIFIER '
  if type_check == 1:
    p[0] = p[1] + p[2]
  if gen_IR == 1:
    p[0] = p[1] + p[2]

def p_2(p):
  'Type : PrimitiveType '
  p[0] = ['PrimitiveType', p[1]]

def p_3(p):
  'Type : ReferenceType '
  p[0] = p[1]

def p_4(p):
  'PrimitiveType : NumericType '
  p[0] = p[1]

def p_5(p):
  'PrimitiveType : BOOLEAN '
  p[0] = 'BOOLEAN'

def p_6(p):
  'NumericType : BYTE '
  p[0] = 'BYTE'

def p_7(p):
  'NumericType : SHORT '
  p[0] = 'SHORT'

def p_8(p):
  'NumericType : INT '
  p[0] = 'INT'

def p_9(p):
  'NumericType : LONG '
  p[0] = 'LONG'

def p_10(p):
  'NumericType : CHAR '
  p[0] = 'CHAR'

def p_11(p):
  'NumericType : FLOAT '
  p[0] = 'FLOAT'

def p_12(p):
  'NumericType : DOUBLE '
  p[0] = 'DOUBLE'

def p_13(p):
  'ReferenceType : ClassType '
  if gen_symbol_table == 1:
    p[0] = ['ClassType', p[1]]
  elif gen_IR == 1:
    p[0] = ['ClassType', p[1]]
  else:
    p[0] = p[1]

def p_14(p):
  'ReferenceType : ArrayType '
  p[0] = ['ArrayType', p[1]]

def p_15(p):
  'temporary0 : temporary0 IDENTIFIER DOT '
  p[0] = p[1] + p[2] + '.'

def p_16(p):
  'temporary0 : IDENTIFIER DOT '
  p[0] = p[1] + '.'

def p_17(p):
  'ClassType : IDENTIFIER '
  p[0] = p[1]
  # if gen_symbol_table == 1:
  #   p[0] = p[1]
  # if type_check == 1:
  #   print(p[1])
  #   search_result, _ = curr_table.lookup_variable_noerror(p[1])
  #   if search_result != None:
  #     p[0] = [search_result[0][0],[search_result[0][1], search_result[1]]]
  #   else:
  #     search_result = curr_table.lookup_array(p[1])
  #     p[0] = ['ArrayType', [search_result[0], search_result[1], search_result[2]]]

def p_18(p):
  'ClassType : temporary0 IDENTIFIER '
  p[0] = p[1] + p[2]
  # if gen_symbol_table == 1:
  #   p[0] = p[1] + p[2]
  # if type_check == 1:
  #   search_scope = curr_table.lookup_class_recursive(p[1] + p[2])
  #   if p[2] in search_scope.variables:
  #     p[0] = [search_scope.variables[p[2]][0][0], [search_scope.variables[p[2]][0][1], search_scope.variables[p[2]][1]]]
  #   elif p[2] in search_scope.arrays:
  #     temp = search_scope.arrays[p[2]]
  #     p[0] = ['ArrayType', [temp[0], temp[1], temp[2]]]
  #   else:
  #     print(p[1]+p[2],"Not in scope!")


def p_19(p):
  'PostFixType : IDENTIFIER '
  if gen_IR == 1:
    search_result,_ = curr_table.lookup_variable_noerror(p[1])
    if search_result != None:
      if search_result[0][0] == 'PrimitiveType':
        p[0] = [p[1], search_result[0][1]]
      else:
        p[0] = [p[1], 'CLASSREF']
    else:
      search_result = curr_table.lookup_array(p[1])
      p[0] = [p[1], 'ARRAYREF']
  if type_check == 1:
    search_result, _ = curr_table.lookup_variable_noerror(p[1])
    if search_result != None:
      p[0] = [search_result[0][0],[search_result[0][1], search_result[1]]]
    else:
      search_result = curr_table.lookup_array(p[1])
      p[0] = ['ArrayType', [search_result[0], search_result[1], search_result[2]]]

def p_20(p):
  'PostFixType : temporary0 IDENTIFIER '
  if gen_symbol_table == 1: #TODO: Handle it properly
    p[0] = p[1] + p[2]

  if type_check == 1:
    name = p[1] + p[2]
    name_split = name.split('.')
    try_array = curr_table.lookup_array_noerror(".".join(name_split[:-1]))
    if try_array != None and name_split[-1] == 'length':
      p[0] = ['PrimitiveType', ['INT', ['FINAL']]]
    else:
      search_scope = curr_table.lookup_class_recursive(p[1] + p[2])
      if p[2] in search_scope.variables:
        p[0] = [search_scope.variables[p[2]][0][0], [search_scope.variables[p[2]][0][1], search_scope.variables[p[2]][1]]]
      elif p[2] in search_scope.arrays:
        temp = search_scope.arrays[p[2]]
        p[0] = ['ArrayType', [temp[0], temp[1], temp[2]]]
      else:
        print(p[1]+p[2],"Not in scope!")

  if gen_IR == 1:
    name = p[1] + p[2]
    name_split = name.split('.')
    try_array = curr_table.lookup_array_noerror(".".join(name_split[:-1]))
    if try_array != None and name_split[-1] == 'length': #Handle array length operator
      name_split = name_split[:-1]
      new_var = get_newvar()
      IR_list.append(IR("=", name_split[0], "", new_var, curr_table))
      var_name = name_split[0]
      for i in range(1,len(name_split)):
        search_result, var_scope = curr_table.lookup_variable(var_name)
        class_scope = var_scope.lookup_class(search_result[0][1])
        offset = class_scope.variables[name_split[i]][2]
        new_var1 = get_newvar()
        IR_list.append(IR("+INT", new_var, offset, new_var1, curr_table))
        new_var2 = get_newvar()
        IR_list.append(IR("=", new_var1, "", new_var2, curr_table))
        new_var = new_var2
        var_name = var_name + '.' + name_split[i]
      new_var3 = get_newvar()
      IR_list.append(IR("+INT", new_var, 16+8*(try_array[1]-1), new_var3, curr_table))
      new_var4 = get_newvar()
      IR_list.append(IR("=", new_var3, "", new_var4, curr_table))
      p[0] = [new_var4, "INT"]
    else:
      new_var = get_newvar()
      IR_list.append(IR("=", name_split[0], "", new_var, curr_table))
      var_name = name_split[0]
      for i in range(1,len(name_split)):
        search_result, var_scope = curr_table.lookup_variable(var_name)
        class_scope = var_scope.lookup_class(search_result[0][1])
        offset = class_scope.variables[name_split[i]][2]
        new_var1 = get_newvar()
        IR_list.append(IR("+INT", new_var, offset, new_var1, curr_table))
        new_var2 = get_newvar()
        IR_list.append(IR("=", new_var1, "", new_var2, curr_table))
        new_var = new_var2
        var_name = var_name + '.' + name_split[i]
      search_result,_ = curr_table.lookup_variable_noerror(name)
      if search_result != None:
        if search_result[0][0] == 'PrimitiveType':
          p[0] = [new_var1, search_result[0][1]]
        else:
          p[0] = [new_var1, 'CLASSREF']
      else:
        search_result = curr_table.lookup_array(name)
        p[0] = [new_var1, 'ARRAYREF']

def p_21(p):
  'ArrayType : PrimitiveType Dims '
  p[0] = ['PrimitiveType', p[1], p[2]]

def p_22(p):
  'ArrayType : ClassType Dims '
  if gen_symbol_table == 1:
    p[0] = ['ClassType', p[1], p[2]]
  if gen_IR == 1:
    p[0] = ['ClassType', p[1], p[2]]

def p_23(p):
  'Dims : LEFT_SQUARE RIGHT_SQUARE '
  p[0] = 1

def p_24(p):
  'Dims : Dims LEFT_SQUARE RIGHT_SQUARE '
  p[0] = p[1] + 1

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
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters SuperClass Superinterfaces ClassBody '#shivam:we might need to add info like Typeparameters,Modifiers, Super class etc. in the symbol table.
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[6], modifiers = p[1])

def p_56(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters SuperClass ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[5], modifiers = p[1])

def p_57(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters Superinterfaces ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[5], modifiers = p[1])

def p_58(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER SuperClass Superinterfaces ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[5], modifiers = p[1])

def p_59(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER TypeParameters ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[4], modifiers = p[1])

def p_60(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER SuperClass ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[4], modifiers = p[1])

def p_61(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER Superinterfaces ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[4], modifiers = p[1])

def p_62(p):
  'NormalClassDeclaration : ClassModifier IDENTIFIER ClassBody '
  if gen_symbol_table == 1:
    curr_table.add_classes(p[2], p[3], modifiers = p[1])

def p_63(p):
  'ClassModifier : PUBLIC ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_64(p):
  'ClassModifier : PROTECTED ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_65(p):
  'ClassModifier : PRIVATE ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_66(p):
  'ClassModifier : ABSTRACT ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_67(p):
  'ClassModifier : STATIC ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_68(p):
  'ClassModifier : FINAL ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_69(p):
  'ClassModifier : STRICTFP ClassModifier '
  p[0] = [p[1].upper()] + p[2]

def p_70(p):
  'ClassModifier : CLASS '
  p[0] = []

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
  'ClassBody : LEFT_CURLY New_Scope ClassBodyDeclaration RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 

def p_79(p):
  'ClassBody : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 

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
  if gen_symbol_table == 1:
    for i in p[1][2]:
      addvar(p[1][1], i, modifiers=p[1][0])

def addvar(t, v, modifiers=[]): #Type, VarDecId
  if t[0] == 'PrimitiveType':
    if len(v) == 1:
      curr_table.add_variables(v[0], t, get_primitive_type_size(t[1]), modifiers)
    else:
      curr_table.add_arrays(v[0], t ,v[1], modifiers)
  if t[0] == 'ClassType': #Requires further thoughts
    if len(v) == 1:
      curr_table.add_variables(v[0], t, 8, modifiers)
    else:
      curr_table.add_arrays(v[0], t ,v[1], modifiers)
  if t[0] == 'ArrayType':
    if len(v) == 1:
      curr_table.add_arrays(v[0], t[1][:2], t[1][2], modifiers)
    else:
      if t[1][2] == v[1]:
        curr_table.add_arrays(v[0], t[1][:2], t[1][2], modifiers)
      else:
        print("Inconsistent array declaration!")

def p_94(p):
  'FieldModifier : PUBLIC FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_95(p):
  'FieldModifier : PROTECTED FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_96(p):
  'FieldModifier : PRIVATE FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_97(p):
  'FieldModifier : STATIC FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_98(p):
  'FieldModifier : FINAL FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_99(p):
  'FieldModifier : TRANSIENT FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_100(p):
  'FieldModifier : VOLATILE FieldModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1], p[2][2]]

def p_101(p):
  'FieldModifier : Type VariableDeclaratorList '
  p[0] = [[],p[1],p[2]]
  if gen_IR == 1:
    for i in p[2]:
      if len(i) == 4:
        curr_table.scope_init = curr_table.scope_init + IR_list[i[2]: i[3]]

def p_102(p):
  'VariableDeclaratorList : VariableDeclaratorList COMMA VariableDeclarator '
  p[0] = p[1] + [p[3]]

def p_103(p):
  'VariableDeclaratorList : VariableDeclarator '
  p[0] = [p[1]]

def p_104(p):
  'VariableDeclarator : VariableDeclaratorId '
  p[0] = p[1]

def p_105(p):
  'VariableDeclarator : VariableDeclaratorId ASSIGN VariableInitializer '
  if gen_symbol_table == 1:
    p[0] = p[1] #shivam: Here we need to store the value as well in the symbol table, not only it's name
  if type_check == 1:
    var_type, _ = curr_table.lookup_variable_noerror(p[1][0])
    if var_type != None:
      if var_type[0][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
        if biggest_real(var_type[0][1],p[3][1][0]) != var_type[0][1]: #shivam:Check correctness
          print("Lossy conversion from ",p[3][1][0], " to ",var_type[0][1])
          sys.exit(-1)
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[3][0] == 'ClassType':
        if var_type[0][1] != p[3][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
    else:
      var_type = curr_table.lookup_array(p[1][0])
      if var_type[1] != p[3][1][1]:
        print("Array Assignment of differeing dimensions!")
        sys.exit()
      if var_type[0][0] == 'PrimitiveType' and p[3][1][0][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[3][1][0][0] == 'ClassType':
        if var_type[0][1] != p[3][1][0][1]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
      else:
        print("Incompatible Array Assignment")
        sys.exit(-1)
  if gen_IR == 1:
    global counter
    start_index = len(IR_list)
    flag = 1
    for i in p[3]:
      if type(i) != type([]):
        flag = 0
    if flag == 1: #Array created through ArrayInitialzer
      var_type = curr_table.lookup_array(p[1][0])
      dimensions = var_type[1]
      dimension_list = []
      temp = p[3]
      for i in range(dimensions):
        dimension_list.append(len(temp))
        temp = temp[0]
      width = 0
      if var_type[0][0] == 'PrimitiveType':
        width = get_primitive_type_size(var_type[0][1])
      else:
        width = 8
      new_var = get_newvar()
      IR_list.append(IR("+", p[1][0], 8, new_var, curr_table)) #Writing array width
      IR_list.append(IR("=",width,"", new_var, curr_table))
      new_var = get_newvar()
      IR_list.append(IR("+", p[1][0], 12, new_var, curr_table)) #Writing array dimensions
      IR_list.append(IR("=",dimensions,"", new_var, curr_table))
      new_var2 = get_newvar()
      IR_list.append(IR("=",1,"",new_var2, curr_table, comment = "To calculate number of elements"))
      counter_arr = 0
      total = 1
      for i in dimension_list:
        total = total * i
        new_var = get_newvar()
        IR_list.append(IR("=",i,"",new_var, curr_table))
        new_var3 = get_newvar()
        IR_list.append(IR("+",p[1][0],16+8*counter_arr,new_var3, curr_table))
        IR_list.append(IR("=", new_var, "", new_var3, curr_table)) #Writing dimension limit
        new_var4 = get_newvar()
        IR_list.append(IR("*INT", new_var2, i, new_var4, curr_table, comment = "To calculate number of elements")) #Calculating number of elements
        new_var2 = new_var4
        counter_arr = counter_arr + 1
      new_var = get_newvar()
      IR_list.append(IR('*INT', new_var2, width, new_var, curr_table))
      IR_list.append(IR('allocate_mem', new_var, "", p[1][0], curr_table)) #Allocating memory
      #Now we need to initialize the allocated memory
      dim_help = []
      mul = 1
      for i in range(dimensions):
        dim_num = dimensions-1-i
        dim_help = [[dimension_list[dim_num], mul]] + dim_help
        mul = mul * dimension_list[dim_num]
      new_var = get_newvar()
      IR_list.append(IR("=", p[1][0], "", new_var, curr_table))
      for i in range(total):
        index_list = []
        t = i
        for j in dim_help:
          index_list.append(t // j[1])
          t = t % j[1]
        value = p[3]
        for j in index_list:
          value = value[j]
        value = value[0]
        new_var1 = get_newvar()
        IR_list.append(IR("+",new_var,width*i,new_var1, curr_table))
        IR_list.append(IR("=", value,"", new_var1, curr_table))
      p[0] = [p[1], 'ARRAYREF']
    elif type(p[3][1]) == type([]): #Array made through Array Creation Expression
      new_var1 = get_newvar()
      IR_list.append(IR("+",p[1][0],8,new_var1, curr_table)) #Write field width
      IR_list.append(IR("=",get_primitive_type_size(p[3][0]),'',new_var1, curr_table))
      new_var2 = get_newvar()
      IR_list.append(IR("+",p[1][0],12,new_var2, curr_table)) #Write number of dimensions
      IR_list.append(IR("=",len(p[3][1]),'',new_var2, curr_table))
      new_var3 = get_newvar()
      IR_list.append(IR("=",1,"",new_var3, curr_table, comment = "To calculate number of elements"))
      counter_arr = 0
      for exp in p[3][1]: #Caloculate total number of elements and write each index max val
        new_var = get_newvar()
        IR_list.append(IR("=",exp[0],"",new_var, curr_table))
        new_var4 = get_newvar()
        IR_list.append(IR('*INT',new_var,new_var3,new_var4, curr_table, comment = "To calculate number of elements"))
        new_var3 = new_var4
        new_var5 = get_newvar()
        IR_list.append(IR("+",p[1][0],16+8*counter_arr,new_var5, curr_table))
        IR_list.append(IR("=",new_var,"", new_var5, curr_table))
        counter_arr = counter_arr + 1
      new_var6 = get_newvar()
      IR_list.append(IR('*INT',new_var3,get_primitive_type_size(p[3][0]),new_var6, curr_table))
      IR_list.append(IR('allocate_mem', new_var6, "", p[1][0], curr_table))
      p[0] = [p[1], 'ARRAYREF']
    else:
      var_type, _ = curr_table.lookup_variable_noerror(p[1][0])
      source2 = p[3][0]
      if var_type[0][1] != p[3][1]:
        source2 = "t_"+ str(counter)
        counter = counter + 1
        IR_list.append( IR("cast_to_"+var_type[0][1], p[3][0], "", source2, curr_table))
      instr = IR("=",source2,"",p[1][0], curr_table)
      IR_list.append(instr)
      p[0] = [p[1][0], p[3][1]]
    p[0] = p[0] + [start_index, len(IR_list)]
 
def p_106(p):
  'VariableDeclaratorId : IDENTIFIER '
  p[0] = [p[1]]

def p_107(p):
  'VariableDeclaratorId : IDENTIFIER Dims '
  p[0] = [p[1], p[2]]

def p_108(p):
  'VariableInitializer : Expression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_109(p):
  'VariableInitializer : ArrayInitializer '
  if type_check == 1:
    if len(p[1]) == 0:
      p[0] = []
    else:
      p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_110(p):
  'MethodDeclaration : InterfaceMethodDeclaration '

def p_111(p):
  'MethodDeclaration : FINAL InterfaceMethodDeclaration '

def p_112(p):
  'MethodHeader : Type MethodDeclarator '
  p[0] = [p[1], p[2]]

def p_113(p):
  'MethodHeader : Type MethodDeclarator Throws '
  p[0] = [p[1], p[2]]

def p_114(p):
  'MethodHeader : TypeParameters Type MethodDeclarator '
  p[0] = [p[2], p[3]]

def p_115(p):
  'MethodHeader : TypeParameters Type MethodDeclarator Throws '
  p[0] = [p[2], p[3]]

def p_116(p):
  'MethodHeader : VOID MethodDeclarator '
  p[0] = [['PrimitiveType','VOID'], p[2]]

def p_117(p):
  'MethodHeader : VOID MethodDeclarator Throws '
  p[0] = [['PrimitiveType','VOID'], p[2]]

def p_118(p):
  'MethodHeader : TypeParameters VOID MethodDeclarator '
  p[0] = [['PrimitiveType','VOID'], p[3]]

def p_119(p):
  'MethodHeader : TypeParameters VOID MethodDeclarator Throws '
  p[0] = [['PrimitiveType','VOID'], p[3]]

def p_120(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN Dims '
  p[0] = [p[1], p[3], p[5]]

def p_121(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN Dims '
  p[0] = [p[1], [], p[4]]

def p_122(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '
  p[0] = [p[1], p[3], 0]

def p_123(p):
  'MethodDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  p[0] = [p[1], [], 0]

def p_124(p):
  'FormalParameterList : ReceiverParameter '
  p[0] = p[1]

def p_125(p):
  'FormalParameterList : FormalParameters COMMA LastFormalParameter '
  p[0] = p[1] + p[3]

def p_126(p):
  'FormalParameterList : LastFormalParameter '
  p[0] = p[1]

def p_127(p):
  'FormalParameters : FormalParameters COMMA FormalParameter '
  p[0] = p[1] + p[3]

def p_128(p):
  'FormalParameters : FormalParameter '
  p[0] = p[1]

def p_129(p):
  'FormalParameters : ReceiverParameter '
  p[0] = p[1]

def p_130(p):
  'FormalParameter : FINAL Type VariableDeclaratorId '
  p[0] = [[p[2], p[3]]]

def p_131(p):
  'FormalParameter : Type VariableDeclaratorId '
  p[0] = [[p[1], p[2]]]

def p_132(p):
  'LastFormalParameter : FINAL Type TRIPLE_DOT VariableDeclaratorId '
  p[0] = [[p[2], p[4]]] #TODO: Handle Varargs

def p_133(p):
  'LastFormalParameter : Type TRIPLE_DOT VariableDeclaratorId '
  p[0] = [[p[1], p[3]]] #TODO: Handle Varargs

def p_134(p):
  'LastFormalParameter : FormalParameter '
  p[0] = p[1]

def p_135(p):
  'ReceiverParameter : Type THIS '
  p[0] = [[p[1], ['this']]]
  if type_check == 1:
  #Shivam: What id this syntax. All the used of 'this' keyword, I know are satisfied by other grammar rules
    print("Unsupported 'this' syntax!")
    sys.exit(-1)

def p_136(p):
  'ReceiverParameter : Type IDENTIFIER DOT THIS '
  p[0] = [[p[1], [p[2] + '.this']]]
  if type_check == 1:
  #Shivam: What id this syntax. All the used of 'this' keyword, I know are satisfied by other grammar rules
    print("Unsupported 'this' syntax!")
    sys.exit(-1)

def p_137(p):
  'Throws : THROWS ExceptionTypeList '

def p_138(p):
  'ExceptionTypeList : ExceptionTypeList COMMA ClassType '

def p_139(p):
  'ExceptionTypeList : ClassType '

def p_140(p):
  'MethodBody : Block '
  if gen_symbol_table == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_141(p):
  'MethodBody : SEMI_COLON '
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    new_table = symbol_table(next_num, curr_table)
    next_num+=1
    table_list.append(new_table)
    curr_table.child.append(new_table)
    curr_table = new_table
    p[0] = curr_table
    curr_table = curr_table.parent
  else:
    next_num+=1

def p_142(p):
  'ConstructorDeclaration : ConstructorModifier Throws ConstructorBody '
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    save_table = curr_table
    curr_table = p[3]
    argument_list = []
    for i in p[1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
      addvar(i[0], i[1])
    curr_table = save_table
    curr_table.add_functions(p[1][1][0], [], argument_list, p[3], is_constructor = 1, modifiers=p[1][0])
  if gen_IR == 1:
    argument_list = []
    for i in p[1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
    counter_arr = 0
    found = 0
    for one_func in curr_table.functions[p[1][1][0]]:
      if one_func[1] == argument_list:
        curr_table.functions[p[1][1][0]][counter_arr].append(IR_list[p[3][0]: p[3][1]])
        found = 1
        break
      counter_arr = counter_arr + 1

def p_143(p):
  'ConstructorDeclaration : ConstructorModifier ConstructorBody '
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    save_table = curr_table
    curr_table = p[2]
    argument_list = []
    for i in p[1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
      addvar(i[0], i[1])
    curr_table = save_table
    curr_table.add_functions(p[1][1][0], [], argument_list, p[2], is_constructor = 1, modifiers=p[1][0])
  if gen_IR == 1:
    argument_list = []
    for i in p[1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
    counter_arr = 0
    found = 0
    for one_func in curr_table.functions[p[1][1][0]]:
      if one_func[1] == argument_list:
        curr_table.functions[p[1][1][0]][counter_arr].append(IR_list[p[2][0]: p[2][1]])
        found = 1
        break
      counter_arr = counter_arr + 1

def p_144(p):
  'ConstructorModifier : PUBLIC ConstructorModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_145(p):
  'ConstructorModifier : PROTECTED ConstructorModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_146(p):
  'ConstructorModifier : PRIVATE ConstructorModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_147(p):
  'ConstructorModifier : ConstructorDeclarator '
  p[0] = [[], p[1]]

def p_148(p):
  'ConstructorDeclarator : TypeParameters IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '
  p[0] = [p[2], p[4]]

def p_149(p):
  'ConstructorDeclarator : TypeParameters IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  p[0] = [p[2], []]

def p_150(p):
  'ConstructorDeclarator : IDENTIFIER LEFT_PAREN FormalParameterList RIGHT_PAREN '
  p[0] = [p[1], p[3]]

def p_151(p):
  'ConstructorDeclarator : IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  p[0] = [p[1], []]

def p_152(p):
  'ConstructorBody : LEFT_CURLY New_Scope ExplicitConstructorInvocation BlockStatements RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent
  if gen_IR == 1:
    p[0] = [p[2], len(IR_list)] 

def p_153(p):
  'ConstructorBody : LEFT_CURLY New_Scope BlockStatements RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    p[0] = [p[2], len(IR_list)] 

def p_154(p):
  'ConstructorBody : LEFT_CURLY New_Scope ExplicitConstructorInvocation RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    p[0] = [p[2], len(IR_list)] 

def p_155(p):
  'ConstructorBody : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    p[0] = [p[2], len(IR_list)] 

def p_156(p):
  'ExplicitConstructorInvocation : THIS LEFT_PAREN ArgumentList RIGHT_PAREN SEMI_COLON '
  if type_check == 1:
    #Go up th scope until until we find a class whose scope is current scope
    parent_scope = curr_table.parent
    child_scope = curr_table
    class_name = ""
    class_scope = None
    while parent_scope != None:
      flag = 0
      for classes in parent_scope.classes:
        if parent_scope.classes[classes][1] == child_scope:
          #This is our target class
          class_name = classes
          class_scope = child_scope
          flag = 1
          break
      if flag == 1:
        break
      else:
        child_scope = parent_scope
        parent_scope = parent_scope.parent
    if class_scope == None:
      print("Invalid use of 'this' keyword!")
      sys.exit(-1)

    search_result = class_scope
    lookup_result = search_result.functions[class_name]
    if lookup_result == None:
      print("No constructor defined for class", class_name)
      sys.exit(-1)
    test = 0
    for function in lookup_result:
        if len(function[1]) != len(p[4]):
            continue
        check = 1
        for i in range(len(p[4])):
            if function[1][i][0] == "PrimitiveType" and p[4][i][0] == "PrimitiveType" and function[1][i][1] == p[4][i][1][0]:
                continue
            elif function[1][i][0] == "ClassType" and p[4][i][0] == "ClassType" and function[1][i][1] == p[4][i][1][0]:
                continue
            elif function[1][i][0] == "ArrayType" and p[4][i][0] == "ArrayType" and function[1][i][1] == p[4][i][1][0] and function[1][i][2] == p[4][i][1][1]:
                continue
            else:
                check = 0
                break
        if check == 1:
            p[0] = ['ClassType', [class_name, []]]
            test = 1
            break
        else:
            continue
    if test == 0:
        print("Invalid Arguments to constructor")
        sys.exit(-1)

def p_157(p):
  'ExplicitConstructorInvocation : THIS LEFT_PAREN RIGHT_PAREN SEMI_COLON '
  if type_check == 1:
    parent_scope = curr_table.parent
    child_scope = curr_table
    class_name = ""
    class_scope = None
    while parent_scope != None:
      flag = 0
      for classes in parent_scope.classes:
        if parent_scope.classes[classes][1] == child_scope:
          #This is our target class
          class_name = classes
          class_scope = child_scope
          flag = 1
          break
      if flag == 1:
        break
      else:
        child_scope = parent_scope
        parent_scope = parent_scope.parent
    if class_scope == None:
      print("Invalid use of 'this' keyword!")
      sys.exit(-1)

    search_result = class_scope
    if class_name in search_result.functions:
      check = 0
      for one_func in search_result.functions[class_name]:
        if len(one_func[1]) == 0: #Good to go
          check = 1
      if check == 0:
        print("No empty constructor available!")
        sys.exit(-1)
      else:
        p[0] = ['ClassType', [class_name, []]]
    else: #Default constructor is empty, good to go
      p[0] = ['ClassType', [class_name, []]]

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
  p[0] = ['PUBLIC'] + p[2]

def p_165(p):
  'ClassModifier_enum : PROTECTED ClassModifier_enum '
  p[0] = ['PROTECTED'] + p[2]

def p_166(p):
  'ClassModifier_enum : PRIVATE ClassModifier_enum '
  p[0] = ['PRIVATE'] + p[2]

def p_167(p):
  'ClassModifier_enum : ABSTRACT ClassModifier_enum '
  p[0] = ['ABSTRACT'] + p[2]

def p_168(p):
  'ClassModifier_enum : STATIC ClassModifier_enum '
  p[0] = ['STATIC'] + p[2]

def p_169(p):
  'ClassModifier_enum : FINAL ClassModifier_enum '
  p[0] = ['FINAL'] + p[2]

def p_170(p):
  'ClassModifier_enum : STRICTFP ClassModifier_enum '
  p[0] = ['STRICTFP'] + p[2]

def p_171(p):
  'ClassModifier_enum : ENUM '
  p[0] = []

def p_172(p):
  'EnumDeclaration : ClassModifier_enum IDENTIFIER Superinterfaces EnumBody '
  print("Enum implementing interfaces not supported!")
  sys.exit(-1)

def p_173(p):
  'EnumDeclaration : ClassModifier_enum IDENTIFIER EnumBody '
  if gen_symbol_table == 1:
    curr_table.add_enums(p[2], p[3], p[1])

def p_174(p):
  'EnumBody : LEFT_CURLY New_Scope EnumConstantList COMMA EnumBodyDeclaration RIGHT_CURLY '
  print("Advanced Enums (Enum with EnumBodyDeclaration) not supported!")
  sys.exit(-1)
  global curr_table
  curr_table = curr_table.parent 

def p_175(p):
  'EnumBody : LEFT_CURLY New_Scope COMMA EnumBodyDeclaration RIGHT_CURLY '
  print("Advanced Enums (Enum with EnumBodyDeclaration) not supported!")
  sys.exit(-1)
  global curr_table
  curr_table = curr_table.parent 

def p_176(p):
  'EnumBody : LEFT_CURLY New_Scope EnumConstantList EnumBodyDeclaration RIGHT_CURLY '
  print("Advanced Enums (Enum with EnumBodyDeclaration) not supported!")
  sys.exit(-1)
  global curr_table
  curr_table = curr_table.parent 

def p_177(p):
  'EnumBody : LEFT_CURLY New_Scope EnumConstantList COMMA RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  p[0] = p[3]

def p_178(p):
  'EnumBody : LEFT_CURLY New_Scope EnumConstantList RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  p[0] = p[3]

def p_179(p):
  'EnumBody : LEFT_CURLY New_Scope COMMA RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  p[0] = []

def p_180(p):
  'EnumBody : LEFT_CURLY New_Scope EnumBodyDeclaration RIGHT_CURLY '
  print("Advanced Enums (Enum with EnumBodyDeclaration) not supported!")
  sys.exit(-1)
  global curr_table
  curr_table = curr_table.parent 

def p_181(p):
  'EnumBody : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  p[0] = []

def p_182(p):
  'EnumConstantList : EnumConstantList COMMA EnumConstant '
  p[0] = p[1] + [p[3]]

def p_183(p):
  'EnumConstantList : EnumConstant '
  p[0] = [p[1]]

def p_184(p):
  'EnumConstant : IDENTIFIER '
  p[0] = p[1]

def p_185(p):
  'EnumConstant : IDENTIFIER ClassBody '
  print("Complex enum constants unsupported")
  sys.exit(-1)

def p_186(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  print("Complex enum constants unsupported")
  sys.exit(-1)

def p_187(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  print("Complex enum constants unsupported")
  sys.exit(-1)

def p_188(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN RIGHT_PAREN ClassBody '
  print("Complex enum constants unsupported")
  sys.exit(-1)

def p_189(p):
  'EnumConstant : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody '
  print("Complex enum constants unsupported")
  sys.exit(-1)

def p_190(p):
  'EnumBodyDeclaration : SEMI_COLON ClassBodyDeclaration '

def p_191(p):
  'EnumBodyDeclaration : SEMI_COLON '

def p_192(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER TypeParameters ExtendsInterfaces InterfaceBody '
  if gen_symbol_table == 1:
    curr_table.add_interfaces(p[2], p[5], p[1])

def p_193(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER ExtendsInterfaces InterfaceBody '
  if gen_symbol_table == 1:
    curr_table.add_interfaces(p[2], p[4], p[1])

def p_194(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER TypeParameters InterfaceBody '
  if gen_symbol_table == 1:
    curr_table.add_interfaces(p[2], p[4], p[1])

def p_195(p):
  'InterfaceDeclaration : InterfaceModifier IDENTIFIER InterfaceBody '
  if gen_symbol_table == 1:
    curr_table.add_interfaces(p[2], p[3], p[1])

def p_196(p):
  'InterfaceModifier : PUBLIC InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_197(p):
  'InterfaceModifier : PROTECTED InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_198(p):
  'InterfaceModifier : PRIVATE InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_199(p):
  'InterfaceModifier : ABSTRACT InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_200(p):
  'InterfaceModifier : STATIC InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_201(p):
  'InterfaceModifier : STRICTFP InterfaceModifier '
  p[0] = [p[1].upper()] + p[2]

def p_202(p):
  'InterfaceModifier : INTERFACE '
  p[0] = []

def p_203(p):
  'ExtendsInterfaces : EXTENDS InterfaceTypeList '

def p_204(p):
  'InterfaceBody : LEFT_CURLY New_Scope InterfaceMemberDeclaration RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 

def p_205(p):
  'InterfaceBody : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent 

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
  if gen_symbol_table == 1:
    for i in p[1][1][1]:
      addvar(p[1][1][0], i, modifiers=p[1][0])

def p_217(p):
  'ConstantModifier : PUBLIC ConstantModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_218(p):
  'ConstantModifier : STATIC ConstantModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_219(p):
  'ConstantModifier : FINAL ConstantModifier '
  p[0] = [p[2][0] + [p[1].upper()], p[2][1]]

def p_220(p):
  'ConstantModifier : Type VariableDeclaratorList '
  p[0] = [[], [p[1], p[2]]]

def p_221(p):
  'InterfaceMethodModifier : PUBLIC InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_222(p):
  'InterfaceMethodModifier : PROTECTED InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_223(p):
  'InterfaceMethodModifier : PRIVATE InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_224(p):
  'InterfaceMethodModifier : ABSTRACT InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_225(p):
  'InterfaceMethodModifier : STATIC InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_226(p):
  'InterfaceMethodModifier : STRICTFP InterfaceMethodModifier '
  p[0] = [p[2][0]+[p[1].upper()], p[2][1]]

def p_227(p):
  'InterfaceMethodModifier : MethodHeader '
  p[0] = [[], p[1]]

def p_228(p):
  'InterfaceMethodDeclaration : InterfaceMethodModifier MethodBody '
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    save_curr_table = curr_table
    curr_table = p[2] 
    argument_list = []
    for i in p[1][1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
      addvar(i[0], i[1])
    curr_table = save_curr_table
    curr_table.add_functions(p[1][1][1][0], p[1][1][0], argument_list, p[2], modifiers=p[1][0])
  if gen_IR == 1: #IntMetMod returns same things, methodbody return [start_index, end_index] of body
    argument_list = []
    for i in p[1][1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
    counter_arr = 0
    found = 0
    for one_func in curr_table.functions[p[1][1][1][0]]:
      if one_func[1] == argument_list:
        curr_table.functions[p[1][1][1][0]][counter_arr].append(IR_list[p[2][0]: p[2][1]])
        found = 1
        break
      counter_arr = counter_arr + 1


def p_229(p):
  'InterfaceMethodDeclaration : AT_RATE InterfaceMethodModifier MethodBody '
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    save_curr_table = curr_table
    curr_table = p[3] 
    argument_list = []
    for i in p[2][1][1][1]:
      if len(i[1]) == 2:
        argument_list.append(['ArrayType', i[0], i[1][1]])
      elif i[0][0] == 'ArrayType':
        argument_list.append(['ArrayType', [i[0][1][0], i[0][1][1]], i[0][1][2]])
      else:
        argument_list.append(i[0])
      addvar(i[0], i[1])
    curr_table = save_curr_table
    curr_table.add_functions(p[2][1][1][0], p[2][1][0], argument_list, p[3], modifiers=p[2][0])

def p_230(p):
  'ArrayInitializer : LEFT_CURLY New_Scope VariableInitializerList COMMA RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[3][0] == 'ArrayType':
      p[0] = ['ArrayType', [p[3][1][0], p[3][1][1]+1, []]]
    else:
      p[0] = ['ArrayType', [[p[3][0], p[3][1][0]], 1, []]]
  if gen_IR == 1:
    p[0] = p[3]

def p_231(p):
  'ArrayInitializer : LEFT_CURLY New_Scope COMMA RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent
  if type_check == 1:
    print("Empty Initilaization not supported!")
    sys.exit(-1)

def p_232(p):
  'ArrayInitializer : LEFT_CURLY New_Scope VariableInitializerList RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[3][0] == 'ArrayType':
      p[0] = ['ArrayType', [p[3][1][0], p[3][1][1]+1, []]]
    else:
      p[0] = ['ArrayType', [[p[3][0], p[3][1][0]], 1, []]]
  if gen_IR == 1:
    p[0] = p[3]

def p_233(p):
  'ArrayInitializer : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    print("Empty Initilaization not supported!")
    sys.exit(-1)

def p_234(p):
  'VariableInitializerList : VariableInitializerList COMMA VariableInitializer '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType' and p[1][1][0] == p[3][1][0]:
      p[0] = p[1]
    elif p[1][0] == 'ClassType' and p[3][0] == 'ClassType' and p[1][1][0] == p[3][1][0]:
      p[0] = p[1]
    elif p[1][0] == 'ArrayType' and p[3][0] == 'ArrayType':
      if p[1][1][0][0] == 'PrimitiveType' and p[3][1][0][0] == 'PrimitiveType' and p[1][1][0][1] == p[3][1][0][1]:
        p[0] = p[1]
      elif p[1][1][0][0] == 'ClassType' and p[3][1][0][0] == 'ClassType' and p[1][1][0][1] == p[3][1][0][1]:
        p[0] = p[1]
      else:
        print("Incompatible Array Assignment")
        sys.exit(-1)
    else:
      print("Incompatible Array Assignment")
      sys.exit(-1)
  if gen_IR == 1:
    p[0] = p[1] + [p[3]]

def p_235(p):
  'VariableInitializerList : VariableInitializer '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = [p[1]]

def p_236(p):
  'Block : LEFT_CURLY New_Scope BlockStatements RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  curr_table = curr_table.parent
  if gen_IR == 1:
    p[0] = [p[2], len(IR_list)] 

def p_237(p):
  'Block : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  if gen_symbol_table == 1:
    p[0] = curr_table
  if gen_IR == 1:
    p[0] = [len(IR_list), len(IR_list)]
  curr_table = curr_table.parent 

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
  if gen_symbol_table == 1:
    for i in p[3]:
      addvar(p[2], i, modifiers = ['FINAL'])

def p_245(p):
  'LocalVariableDeclaration : Type VariableDeclaratorList '
  if gen_symbol_table == 1:
    for i in p[2]:
      addvar(p[1], i)

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
  if gen_IR == 1:
    p[0] = p[1]

def p_278(p):
  'StatementExpression : ClassInstanceCreationExpression '

def p_279(p):
  'IfThenStatement : IF LEFT_PAREN Expression RIGHT_PAREN Next Statement '
  if type_check == 1:
    if p[3][0] !='PrimitiveType' or p[3][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1) 

  if gen_IR == 1:
    global counter
    global IR_list
    exp1_end = p[5]
    new_label = get_newlabel()
    inst = IR("goto", "ifFalse", p[3][0], new_label, curr_table)
    IR_list = IR_list[:exp1_end+1] + [inst] + IR_list[exp1_end+1:]
    IR_list.append(IR("label:", new_label, "","", curr_table))

#    IR_list.append(IR("goto",str(p[6]),"","if "+p[4][0],curr_table))
#    IR_list.append(IR("goto", "", "", "", curr_table))
#    backpatch(p[3][2], p[4])
#    p[0] = p[7] + [p[4] + 1]  #shivam: Just passing the nextlist of each statement


def p_280(p):
  'IfThenElseStatement : IF LEFT_PAREN Expression RIGHT_PAREN Next StatementNoShortIf ELSE Next Statement '
  if type_check == 1:
    if p[3][0] !='PrimitiveType' or p[3][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1) 

  if gen_IR == 1:
    global counter
    global IR_list
    exp1_end = p[5]
    statement1_end = p[8]
    new_label1 = get_newlabel()
    new_label2 = get_newlabel()
    inst1 = IR("goto", "ifFalse", p[3][0], new_label1, curr_table)
    inst2 = IR("goto","","",new_label2,curr_table)
    inst3 = IR("label:",new_label1,"","",curr_table)
    IR_list = IR_list[:exp1_end+1] + [inst1] + IR_list[exp1_end+1:statement1_end+1] + [inst2,inst3] + IR_list[statement1_end+1:]
    IR_list.append(IR("label:", new_label2, "","", curr_table))
#  if gen_IR == 1:
#    IR_list[p[4]].dest = "if "+p[3][0]
#    IR_list[p[4]].source1 = str(p[6])
#    IR_list[p[4] + 1].source1 = str(p[10])
#    IR_list.append(IR("goto",str(p[6]),"","if "+p[4][0],curr_table))
#    IR_list.append(IR("goto",str(p[10]), "", "", curr_table))
#    backpatch(p[3][2], p[4])
#    p[0] = p[11] + [p[8]]  #shivam: Just passing the nextlist of each statement


def p_281(p):
  'IfThenElseStatementNoShortIf : IF LEFT_PAREN Expression RIGHT_PAREN Next StatementNoShortIf ELSE Next StatementNoShortIf '
  if type_check == 1:
    if p[3][0] !='PrimitiveType' or p[3][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1) 

  if gen_IR == 1:
    global counter
    global IR_list
    exp1_end = p[5]
    statement1_end = p[8]
    new_label1 = get_newlabel()
    new_label2 = get_newlabel()
    inst1 = IR("goto", "ifFalse", p[3][0], new_label1, curr_table)
    inst2 = IR("goto","","",new_label2,curr_table)
    inst3 = IR("label:",new_label1,"","",curr_table)
    IR_list = IR_list[:exp1_end+1] + [inst1] + IR_list[exp1_end+1:statement1_end+1] + [inst2,inst3] + IR_list[statement1_end+1:]
    IR_list.append(IR("label:", new_label2, "","", curr_table))
#    IR_list.append(IR("goto",str(p[6]),"","if "+p[4][0],curr_table))
#    IR_list.append(IR("goto",str(p[10]), "", "", curr_table))
#    backpatch(p[3][2], p[4])
#    p[0] = p[11] + [p[8]]  #shivam: Just passing the nextlist of each statement


def p_282(p):
  'AssertStatement : ASSERT Expression SEMI_COLON '
  if type_check == 1:
    if p[2][0] !='PrimitiveType' or p[2][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1) 

  if gen_IR == 1:
    IR_list.append(IR("goto","","","ifFalse "+str(p[2][0]),curr_table))
    IR_list.append(IR("exit()","","","",curr_table))
    p[0] = p[2][2] + [len(IR_list)-2]

def p_283(p):
  'AssertStatement : ASSERT Expression COLON Expression SEMI_COLON '
  if type_check == 1:
    print("Unsupported assert syntax!") #TODO: Handle this
    sys.exit(-1)

def p_284(p):
  'SwitchStatement : SWITCH LEFT_PAREN Expression RIGHT_PAREN SwitchBlock '
  if type_check == 1:
    if p[3][0] != 'PrimitiveType' or p[3][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG', 'CHAR']:
      print("Switch statement takes only numeric type")
      sys.exit(-1)

def p_285(p):
  'SwitchBlock : LEFT_CURLY New_Scope SwitchBlockStatementGroup SwitchLabels RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 

def p_286(p):
  'SwitchBlock : LEFT_CURLY New_Scope SwitchLabels RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 

def p_287(p):
  'SwitchBlock : LEFT_CURLY New_Scope SwitchBlockStatementGroup RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 

def p_288(p):
  'SwitchBlock : LEFT_CURLY New_Scope RIGHT_CURLY '
  global curr_table
  curr_table = curr_table.parent 

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
  if type_check == 1:
    if p[2][0] != 'PrimitiveType' or p[2][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG', 'CHAR']:
      print("Switch statement takes only numeric type")
      sys.exit(-1)

def p_294(p):
  'SwitchLabel : DEFAULT COLON '

def p_295(p):
  'WhileStatement : WHILE Next LEFT_PAREN Expression Gen_If RIGHT_PAREN Next Statement '
  global IR_list
  if type_check == 1:
    if p[4][0] != 'PrimitiveType' or p[4][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    expression_start = p[2]
    expression_end = p[5]
    statement_start = p[7]
    exp_start_label = get_newlabel()
    statement_end_label = get_newlabel()
    inst1 = IR("label:", exp_start_label, "", "", curr_table)
    inst2 = IR("goto", "ifFalse", p[4][0], statement_end_label, curr_table)
    #Handling break and continue statement
    for i in range(expression_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", statement_end_label, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", exp_start_label, curr_table)
    IR_list = IR_list[:expression_start+1] + [inst1] + IR_list[expression_start+1:expression_end+1] + [inst2] + IR_list[expression_end+1:]
    IR_list.append(IR("goto", "", "", exp_start_label, curr_table))
    IR_list.append(IR("label:", statement_end_label, "", "", curr_table))
    # IR_list[p[5]].dest = "if "+p[4][0]
    # IR_list[p[5]].source1 = str(p[7])
    # backpatch(p[4][2], p[5])
    # backpatch(p[8], p[2])
    # IR_list.append(IR("goto",str(p[2]),"","",curr_table))
    # p[0] = [p[5]+1] 

def p_296(p):
  'WhileStatementNoShortIf : WHILE Next LEFT_PAREN Expression Gen_If RIGHT_PAREN Next StatementNoShortIf '
  global IR_list
  if type_check == 1:
    if p[4][0] != 'PrimitiveType' or p[4][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    expression_start = p[2]
    expression_end = p[5]
    statement_start = p[7]
    exp_start_label = get_newlabel()
    statement_end_label = get_newlabel()
    inst1 = IR("label:", exp_start_label, "", "", curr_table)
    inst2 = IR("goto", "ifFalse", p[4][0], statement_end_label, curr_table)
    #Handling break and continue statement
    for i in range(expression_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", statement_end_label, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", exp_start_label, curr_table)
    IR_list = IR_list[:expression_start+1] + [inst1] + IR_list[expression_start+1:expression_end+1] + [inst2] + IR_list[expression_end+1:]
    IR_list.append(IR("goto", "", "", exp_start_label, curr_table))
    IR_list.append(IR("label:", statement_end_label, "", "", curr_table))
    # IR_list[p[5]].dest = "if "+p[4][0]
    # IR_list[p[5]].source1 = str(p[7])
    # backpatch(p[4][2], p[5])
    # backpatch(p[8], p[2])
    # IR_list.append(IR("goto",str(p[2]),"","",curr_table))
    # p[0] = [p[5]+1] 

def p_297(p):
  'DoStatement : DO Next Statement WHILE Next LEFT_PAREN Expression Gen_If RIGHT_PAREN SEMI_COLON '
  global IR_list
  if type_check == 1:
    if p[7][0] != 'PrimitiveType' or p[7][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)
  if gen_IR == 1:
    statement_start = p[2]
    expression_start = p[5]
    statement_start_label = get_newlabel()
    exp_start_label = get_newlabel()
    loop_end_label = get_newlabel()
    inst = IR("label:", statement_start_label, "", "", curr_table)
    inst2 = IR("label:", exp_start_label, "", "", curr_table)
    inst3 = IR("label:", loop_end_label, "", "", curr_table)
    #Handling break and continue statement
    for i in range(statement_start+1, expression_start+1):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", loop_end_label, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", exp_start_label, curr_table)
    IR_list = IR_list[:statement_start+1] + [inst] + IR_list[statement_start+1: expression_start+1] + [inst2] + IR_list[expression_start+1:]
    IR_list.append(IR("goto", "ifTrue", p[7][0], statement_start_label, curr_table))
    IR_list = IR_list + [inst3]

def p_298(p):
  'ForStatement : BasicForStatement '
  if gen_IR == 1:
    p[0] = p[1]

def p_299(p):
  'ForStatement : EnhancedForStatement '
  if gen_IR == 1:
    print("Enhanced for statement not supported in IR_generation")
    sys.exit(-1)

def p_300(p):
  'ForStatementNoShortIf : BasicForStatementNoShortIf '
  if gen_IR == 1:
    p[0] = p[1]

def p_301(p):
  'ForStatementNoShortIf : EnhancedForStatementNoShortIf '
  if gen_IR == 1:
    p[0] = p[1]

def p_302(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next Expression SEMI_COLON Next ForUpdate RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[7][0] != 'PrimitiveType' or p[7][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[9]
    update_end = p[12]
    label_expression = get_newlabel()
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[7][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2,inst6] + IR_list[exp_end+1:update_end+1] + [inst4,inst7] + IR_list[update_end+1:] + [inst3,inst8]





def p_303(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN SEMI_COLON Next Expression SEMI_COLON Next ForUpdate RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[6][0] != 'PrimitiveType' or p[6][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[8]
    update_end = p[11]
    label_expression = get_newlabel()
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[6][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2,inst6] + IR_list[exp_end+1:update_end+1] + [inst4,inst7] + IR_list[update_end+1:] + [inst3,inst8]

def p_304(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next SEMI_COLON Next ForUpdate RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[8]
    update_end = p[11]
    label_update = get_newlabel()
    label_end = get_newlabel()
    label_statement = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + [inst1,inst6] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_305(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next Expression SEMI_COLON Next RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[7][0] != 'PrimitiveType' or p[7][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[9]
    update_end = p[11]
    label_expression = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[7][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_expression, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst4,inst8]



def p_306(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next SEMI_COLON Next RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[8]
    update_end = p[10]
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_statement, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst1,inst8]


def p_307(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN SEMI_COLON Next Expression SEMI_COLON Next RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[6][0] != 'PrimitiveType' or p[6][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[8]
    update_end = p[10]
    label_expression = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[6][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_expression, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst4,inst8]


def p_308(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN SEMI_COLON Next SEMI_COLON Next ForUpdate RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[7]
    update_end = p[10]
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst3 = IR("goto", "", "", label_update,curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + [inst1,inst6] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_309(p):
  'BasicForStatement : FOR New_Scope LEFT_PAREN SEMI_COLON Next SEMI_COLON Next RIGHT_PAREN Next Statement '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[7]
    update_end = p[9]
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_statement, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst1,inst8]


def p_310(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next Expression SEMI_COLON Next ForUpdate RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[7][0] != 'PrimitiveType' or p[7][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[9]
    update_end = p[12]
    label_expression = get_newlabel()
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[7][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2,inst6] + IR_list[exp_end+1:update_end+1] + [inst4,inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_311(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN SEMI_COLON Next Expression SEMI_COLON Next ForUpdate RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[6][0] != 'PrimitiveType' or p[6][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[8]
    update_end = p[11]
    label_expression = get_newlabel()
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[6][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2,inst6] + IR_list[exp_end+1:update_end+1] + [inst4,inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_312(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next SEMI_COLON Next ForUpdate RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[8]
    update_end = p[11]
    label_update = get_newlabel()
    label_end = get_newlabel()
    label_statement = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst3 = IR("goto", "","",label_update,curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + [inst1,inst6] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_313(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next Expression SEMI_COLON Next RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[7][0] != 'PrimitiveType' or p[7][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[9]
    update_end = p[11]
    label_expression = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[7][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_expression, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst4,inst8]


def p_314(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN ForInit SEMI_COLON Next SEMI_COLON Next RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[6]
    exp_end = p[8]
    update_end = p[10]
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_statement, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst1,inst8]


def p_315(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN SEMI_COLON Next Expression SEMI_COLON Next RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if type_check == 1:
    if p[6][0] != 'PrimitiveType' or p[6][1][0] != 'BOOLEAN':
      print("Condition must be a boolean!")
      sys.exit(-1)
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[8]
    update_end = p[10]
    label_expression = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "ifTrue", p[6][0], label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst4 = IR("goto","","",label_expression,curr_table)
    inst5 = IR("label:",label_expression,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_expression, curr_table)
    IR_list = IR_list[:init_end+1] + [inst5] + IR_list[init_end+1:exp_end+1] + [inst1,inst2] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst4,inst8]


def p_316(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN SEMI_COLON Next SEMI_COLON Next ForUpdate RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[7]
    update_end = p[10]
    label_update = get_newlabel()
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst3 = IR("goto", "", "", label_update,curr_table)
    inst6 = IR("label:",label_update,"","",curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_update, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + [inst1,inst6] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst3,inst8]


def p_317(p):
  'BasicForStatementNoShortIf : FOR New_Scope LEFT_PAREN SEMI_COLON Next SEMI_COLON Next RIGHT_PAREN Next StatementNoShortIf '
  global curr_table
  curr_table = curr_table.parent 
  if gen_IR == 1:
    global counter
    global IR_list
    init_end = p[5]
    exp_end = p[7]
    update_end = p[9]
    label_statement = get_newlabel()
    label_end = get_newlabel()
    inst1 = IR("goto", "", "", label_statement , curr_table)
    inst2 = IR("goto", "", "", label_end,curr_table)
    inst7 = IR("label:",label_statement,"","",curr_table)
    inst8 = IR("label:",label_end,"","",curr_table)
    for i in range(update_end+1, len(IR_list)):
      if IR_list[i].opcode == "break" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_end, curr_table)
      if IR_list[i].opcode == "continue" and IR_list[i].destination == "":
        IR_list[i] = IR("goto", "", "", label_statement, curr_table)
    IR_list = IR_list[:init_end+1] + IR_list[init_end+1:exp_end+1] + IR_list[exp_end+1:update_end+1] + [inst7] + IR_list[update_end+1:] + [inst1,inst8]


def p_318(p):
  'ForInit : StatementExpressionList ' 
  if gen_IR == 1:
    p[0] = p[1]

def p_319(p):
  'ForInit : LocalVariableDeclaration '
  if gen_IR == 1:
    p[0] = p[1]

def p_320(p):
  'ForUpdate : StatementExpressionList '
  if gen_IR == 1:
    p[0] = p[1]

def p_321(p):
  'StatementExpressionList : StatementExpressionList COMMA StatementExpression '

def p_322(p):
  'StatementExpressionList : StatementExpression '

def p_323(p):
  'EnhancedForStatement : FOR New_Scope LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement '
  global curr_table
  if gen_symbol_table == 1:
    addvar(p[5], p[6])
  if type_check == 1:
    var_type, _ = curr_table.lookup_variable_noerror(p[6][0])
    if var_type != None:
      if var_type[0][0] == 'PrimitiveType' and p[8][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[8][0] == 'ClassType':
        if var_type[0][1] != p[8][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
    else:
      var_type = curr_table.lookup_array(p[6][0])
      if var_type[0][0] == 'PrimitiveType' and p[8][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[8][0] == 'ClassType':
        if var_type[0][1] != p[8][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass

  curr_table = curr_table.parent 

def p_324(p):
  'EnhancedForStatement : FOR New_Scope LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN Statement '
  global curr_table
  if gen_symbol_table == 1:
    addvar(p[4], p[5])
  if type_check == 1:
    var_type, _ = curr_table.lookup_variable_noerror(p[5][0])
    if var_type != None:
      if var_type[0][0] == 'PrimitiveType' and p[7][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[7][0] == 'ClassType':
        if var_type[0][1] != p[7][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
    else:
      var_type = curr_table.lookup_array(p[5][0])
      if var_type[0][0] == 'PrimitiveType' and p[7][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[7][0] == 'ClassType':
        if var_type[0][1] != p[7][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
  curr_table = curr_table.parent 

def p_325(p):
  'EnhancedForStatementNoShortIf : FOR New_Scope LEFT_PAREN FINAL Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf '
  global curr_table
  if gen_symbol_table == 1:
    addvar(p[5], p[6])
  if type_check == 1:
    var_type, _ = curr_table.lookup_variable_noerror(p[6][0])
    if var_type != None:
      if var_type[0][0] == 'PrimitiveType' and p[8][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[8][0] == 'ClassType':
        if var_type[0][1] != p[8][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
    else:
      var_type = curr_table.lookup_array(p[6][0])
      if var_type[0][0] == 'PrimitiveType' and p[8][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[8][0] == 'ClassType':
        if var_type[0][1] != p[8][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
  curr_table = curr_table.parent 

def p_326(p):
  'EnhancedForStatementNoShortIf : FOR New_Scope LEFT_PAREN Type VariableDeclaratorId COLON Expression RIGHT_PAREN StatementNoShortIf '
  global curr_table
  if gen_symbol_table == 1:
    addvar(p[4], p[5])
  if type_check == 1:
    var_type, _ = curr_table.lookup_variable_noerror(p[5][0])
    if var_type != None:
      if var_type[0][0] == 'PrimitiveType' and p[7][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[7][0] == 'ClassType':
        if var_type[0][1] != p[7][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
    else:
      var_type = curr_table.lookup_array(p[5][0])
      if var_type[0][0] == 'PrimitiveType' and p[7][0] == 'PrimitiveType':
        pass #TODO: Do stricter checking here
      elif var_type[0][0] == 'ClassType' and p[7][0] == 'ClassType':
        if var_type[0][1] != p[7][1][0]:
          print("Incompatible class assignments!")
          sys.exit(-1)
        else:
          pass
  curr_table = curr_table.parent 

def p_327(p):
  'BreakStatement : BREAK IDENTIFIER SEMI_COLON '

def p_328(p):
  'BreakStatement : BREAK SEMI_COLON '
  if gen_IR == 1:
    IR_list.append(IR("break", "", "", "", curr_table))

def p_329(p):
  'ContinueStatement : CONTINUE IDENTIFIER SEMI_COLON '

def p_330(p):
  'ContinueStatement : CONTINUE SEMI_COLON '
  if gen_IR == 1:
    IR_list.append(IR("continue", "", "", "", curr_table))

def p_331(p):
  'ReturnStatement : RETURN Expression SEMI_COLON '
  if gen_IR == 1:
    IR_list.append(IR("return", p[2][0], "", "", curr_table))

def p_332(p):
  'ReturnStatement : RETURN SEMI_COLON '
  if gen_IR == 1:
    IR_list.append(IR("return", "", "", "", curr_table))

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
  if gen_symbol_table == 1:
    addvar(p[2], p[3], modifiers=['FINAL'])

def p_356(p):
  'Resource : Type VariableDeclaratorId ASSIGN Expression '
  if gen_symbol_table == 1:
    addvar(p[1], p[2])

def p_357(p):
  'Primary : PrimaryNoNewArray '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    if type(p[1][1]) == type([]): #It came from Arrayaccess
      new_var = get_newvar()
      IR_list.append(IR("=", p[1][0], "", new_var, curr_table))
      counter_arr = 0
      new_var2 = get_newvar()
      IR_list.append(IR("=",0,"",new_var2, curr_table))
      stride_list = []
      counter_arr = 0
      for i in range(len(p[1][1])):
        new_var3 = get_newvar()
        IR_list.append(IR("+", p[1][0], 16+8*counter_arr, new_var3, curr_table))
        new_var4 = get_newvar()
        IR_list.append(IR("=", new_var3, "", new_var4, curr_table))
        stride_list.append(new_var4)
        counter_arr = counter_arr + 1
      new_var3 = get_newvar()
      IR_list.append(IR("=",1,"",new_var3, curr_table))

      for i in range(len(p[1][1])):
        index = len(p[1][1]) - i -1
        new_var5 = get_newvar()
        IR_list.append(IR("*INT",new_var3, p[1][1][index][0], new_var5, curr_table))
        new_var10 = get_newvar()
        IR_list.append(IR("+INT", new_var2, new_var5, new_var10, curr_table))
        new_var2 = new_var10
        new_var4 = get_newvar()
        IR_list.append(IR("*INT", new_var3, stride_list[index], new_var4, curr_table))
        new_var3 = new_var4

      new_var7 = get_newvar()
      IR_list.append(IR("+INT", p[1][0], 8, new_var7, curr_table))
      new_var8 = get_newvar()
      IR_list.append(IR("=", new_var7, "", new_var8, curr_table))
      new_var11 = get_newvar()
      IR_list.append(IR("*INT", new_var2, new_var8, new_var11, curr_table))
      addr = get_newvar()
      IR_list.append(IR("+INT", new_var, new_var11, addr, curr_table))
      new_var10 = get_newvar()
      IR_list.append(IR("=", addr, "", new_var10, curr_table))
      var_type = curr_table.lookup_array(p[1][0])
      if var_type[0][0] == 'ClassType':
        p[0] = [new_var10, 'CLASSREF']
      else:
        p[0] = [new_var10, var_type[0][1]]
    else:
      p[0] = p[1]

def p_358(p):
  'Primary : ArrayCreationExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1] #This returns value in different syntax than other Primary expressions


def p_359(p):
  'PrimaryNoNewArray : Literal '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_360(p):
  'PrimaryNoNewArray : ClassLiteral '
  #TODO/Shivam : What is this?
  print("Unsupported syntax!")
  sys.exit(-1)

def p_361(p):
  'PrimaryNoNewArray : THIS '
  if type_check == 1:
    parent_scope = curr_table.parent
    child_scope = curr_table
    class_name = ""
    class_scope = None
    while parent_scope != None:
      flag = 0
      for classes in parent_scope.classes:
        if parent_scope.classes[classes][1] == child_scope:
          #This is our target class
          class_name = classes
          class_scope = child_scope
          flag = 1
          break
      if flag == 1:
        break
      else:
        child_scope = parent_scope
        parent_scope = parent_scope.parent
    if class_scope == None:
      print("Invalid use of 'this' keyword!")
      sys.exit(-1)
    p[0] = ['ClassType', [class_name, []]]
  if gen_IR == 1:
    p[0] = ['curr_ref', 'CLASSREF']

def p_362(p):
  'PrimaryNoNewArray : temporary0 THIS '
  if type_check == 1:
    name_split = p[1].split('.')
    var_type, curr_scope = self.lookup_variable(name_split[0])
    if var_type[0][0] != 'ClassType':
      print(name_split[0],"is not a class")
      sys.exit(0)
    curr_scope = curr_scope.lookup_class(var_type[0][1])
    class_name = ""
    for i in range(1,len(name_split)-1):
      var_type = curr_scope.lookup_variable_nonrec(name_split[i])
      if var_type[0] != 'ClassType':
        print(name_split[i],"is not a member of class",name_split[i-1])
        sys.exit(-1)
      curr_scope = curr_scope.lookup_class(var_type[1])
      class_name = var_type[1]
    p[0] = ['ClassType', [class_name, []]]

def p_363(p):
  'PrimaryNoNewArray : LEFT_PAREN Expression RIGHT_PAREN '
  if type_check == 1:
    p[0] = p[2]
  if gen_IR == 1:
    p[0] = p[2]

def p_364(p):
  'PrimaryNoNewArray : ClassInstanceCreationExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_365(p):
  'PrimaryNoNewArray : FieldAccess '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_366(p):
  'PrimaryNoNewArray : ArrayAccess '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_367(p):
  'PrimaryNoNewArray : MethodInvocation '
  if type_check == 1:
      p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_368(p):
  'PrimaryNoNewArray : MethodReference '
  if type_check == 1:
      p[0] = p[1]

def p_369(p):
  'ClassLiteral : ClassType Dims DOT CLASS '
  #TODO/Shivam : What is this?

def p_370(p):
  'ClassLiteral : PrimitiveType Dims DOT CLASS '
  #TODO/Shivam : What is this?

def p_371(p):
  'ClassLiteral : temporary0 CLASS '
  #TODO/Shivam : What is this?

def p_372(p):
  'ClassLiteral : PrimitiveType DOT CLASS '
  #TODO/Shivam : What is this?

def p_373(p):
  'ClassLiteral : VOID DOT CLASS '
  #TODO/Shivam : What is this?

def p_374(p):
  'Literal : INTEGER_LIT '
  if type_check == 1:
    p[0] = ['PrimitiveType',['INT',[]]]
  if gen_IR == 1:
    if p[1][-1] in ['l','L']:
      p[0] = [int(p[1][:-1]),'LONG']
    else:
      p[0] = [int(p[1]),'INT']

def p_375(p):
  'Literal : FLOATING_LIT '
  if type_check == 1:
    p[0] = ['PrimitiveType',['FLOAT',[]]]
  if gen_IR == 1:
      if p[1][-1] in ['f','F']:
        p[0] = [float(p[1][:-1]),'FLOAT']
      elif p[1][-1] in ['d', 'D']:
        p[0] = [float(p[1][:-1]),'DOUBLE']
      else:
        p[0] = [float(p[1]),'FLOAT']

def p_376(p):
  'Literal : BOOLEAN_LIT '
  if type_check == 1:
    p[0] = ['PrimitiveType',['BOOLEAN',[]]]
  if gen_IR == 1:
    p[0] = [p[1], 'BOOL']

def p_377(p):
  'Literal : CHAR_LIT '
  if type_check == 1:
    p[0] = ['PrimitiveType',['CHAR',[]]]
  if gen_IR == 1:
    p[0] = [p[1], 'CHAR']

def p_378(p):
  'Literal : STRING_LIT '
  if type_check == 1:
    p[0] = ['ClassType',['String',[]]]
  if gen_IR == 1:
    p[0] = [p[1], 'STRING']

def p_379(p):
  'Literal : NULL_LIT '
  p[0] = ['NULL',[]]

def p_380(p):
  'ClassInstanceCreationExpression : UnqualifiedClassInstanceCreationExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_381(p):
  'ClassInstanceCreationExpression : temporary0 UnqualifiedClassInstanceCreationExpression '

def p_382(p):
  'ClassInstanceCreationExpression : Primary DOT UnqualifiedClassInstanceCreationExpression '

def p_383(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN ClassBody '
  if type_check == 1:
      search_result = curr_table.lookup_class(p[2][1][0])
      class_name = p[2][1][0].split('.')[-1]
      lookup_result = search_result.functions[class_name]
      if lookup_result == None:
        print("No Constructor defined!")
        sys.exit(-1)
      test = 0
      for function in lookup_result:
          if len(function[1]) != len(p[4]):
              continue
          check = 1
          for i in range(len(p[4])):
              if function[1][i][0] == "PrimitiveType" and p[4][i][0] == "PrimitiveType" and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ClassType" and p[4][i][0] == "ClassType" and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ArrayType" and p[4][i][0] == "ArrayType" and function[1][i][1] == p[4][i][1][0] and function[1][i][2] == p[4][i][1][1]:
                  continue
              else:
                  check = 0
                  break
          if check == 1:
              p[0] = p[2]
              test = 1
              break
          else:
              continue
      if test == 0:
          print("Invalid Arguments to constructor", p[2][1][0])
          sys.exit(-1)
  if gen_IR == 1:
    print("Unsupported Syntax!") #Shivam: Why is classbody there in Class Object creation?
    sys.exit(-1)

def p_384(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
      search_result = curr_table.lookup_class(p[2][1][0])
      class_name = p[2][1][0].split('.')[-1]
      lookup_result = search_result.functions[class_name]
      if lookup_result == None:
        print("No constructor defined!")
        sys.exit(-1)
      test = 0
      for function in lookup_result:
          if len(function[1]) != len(p[4]):
              continue
          check = 1
          for i in range(len(p[4])):
              if function[1][i][0] == "PrimitiveType" and p[4][i][0] == "PrimitiveType" : #TODO: Check compatible_types #and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ClassType" and p[4][i][0] == "ClassType" and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ArrayType" and p[4][i][0] == "ArrayType" and function[1][i][1] == p[4][i][1][0] and function[1][i][2] == p[4][i][1][1]:
                  continue
              else:
                  check = 0
                  break
          if check == 1:
              p[0] = p[2]
              test = 1
              break
          else:
              continue
      if test == 0:
          print("Invalid Arguments to constructor", p[2][1][0])
          sys.exit(-1)
  if gen_IR == 1:
    search_result = curr_table.lookup_class(p[2])
    allocation_size = search_result.size
    new_var = get_newvar()
    IR_list.append(IR("allocate_mem", allocation_size, "", new_var, curr_table))
    p[0] = [new_var, 'CLASSREF']
    if len(search_result.scope_init) > 0:
      IR_list.append(IR("call", search_result.scope_name, "", "", curr_table))
    #Calling appropraite constructor
    lookup_result = search_result.lookup_function(p[2])
    test = 0
    target_function = None
    for function in lookup_result:
        if len(function[1]) != len(p[4]):
            continue
        check = 1
        for i in range(len(p[4])):
            if function[1][i][0] == "PrimitiveType":
              if function[1][i][1] in ['LONG', "INT", "SHORT", "BYTE"] and p[4][i][1] in ['LONG', "INT", "SHORT", "BYTE"]:
                continue
              elif function[1][i][1] in ['FLOAT', 'DOUBLE'] and p[4][i][1] in ['FLOAT', 'DOUBLE']:
                continue
              elif function[1][i][1] == p[4][i][1]:
                continue
              else:
                check = 0
                break
            elif function[1][i][0] == "ClassType" and p[4][i][1] == "CLASSREF":
                class_type, _ = curr_table.lookup_variable_noerror(p[4][i][0])
                if function[1][i][1] == class_type[0][1]:
                  continue
                else:
                  check = 0
                  break
            elif function[1][i][0] == "ArrayType" and p[4][i][1] == "ARRAYREF":
                array_type = curr_table.lookup_array(p[4][i][0])
                if function[1][i][1] == array_type[0]:
                  continue
                else:
                  check = 0
                  break
            else:
                check = 0
                break
        if check == 1:
            target_function = function
            test = 1
            break
    IR_list.append(IR("call", target_function[5], "", "", curr_table))
    #TODO: Call class_initialization and Approriate Constructor. Come back after methodinvocation is implemented

def p_385(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN ClassBody '
  if type_check == 1:
    search_result = curr_table.lookup_class(p[2][1][0])
    #Shivam: Checking if there is a no argument constructor
    class_name = p[2][1][0].split('.')[-1]
    if class_name in search_result.functions:
      check = 0
      for one_func in search_result.functions[class_name]:
        if len(one_func[1]) == 0: #Good to go
          check = 1
      if check == 0:
        print("No empty constructor available!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else: #Default constructor is empty, good to go
      p[0] = p[2]
  if gen_IR == 1:
    print("Unsupported Syntax!") #Shivam: Why is classbody there in Class Object creation?
    sys.exit(-1)

def p_386(p):
  'UnqualifiedClassInstanceCreationExpression : NEW ClassOrInterfaceTypeToInstantiate LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
    search_result = curr_table.lookup_class(p[2][1][0])
    #Shivam: Checking if there is a no argument constructor
    class_name = p[2][1][0].split('.')[-1]
    if class_name in search_result.functions:
      check = 0
      for one_func in search_result.functions[class_name]:
        if len(one_func[1]) == 0: #Good to go
          check = 1
      if check == 0:
        print("No empty constructor available!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else: #Default constructor is empty, good to go
      p[0] = p[2]
  if gen_IR == 1:
    search_result = curr_table.lookup_class(p[2])
    allocation_size = search_result.size
    new_var = get_newvar()
    IR_list.append(IR("allocate_mem", allocation_size, "", new_var, curr_table))
    p[0] = [new_var, 'CLASSREF']
    if len(search_result.scope_init) > 0:
      IR_list.append(IR("call", search_result.scope_name, "", "", curr_table))
    #Calling Appropriate Constructor
    lookup_result = search_result.lookup_function_noerror(p[2])
    if lookup_result != None: #No constructor defined, hence no need for a call
      target_function = None
      for function in lookup_result:
        if len(function[1]) == 0:
          target_function = function
          break 
      IR_list.append(IR("call", target_function[5], "", "", curr_table))
    #TODO: Call class_initialization and Approriate Constructor. Come back after methodinvocation is implemented

def p_387(p):
  'ClassOrInterfaceTypeToInstantiate : TypeName '
  if type_check == 1:
    search_result = curr_table.lookup_class(p[1])
    p[0] = ['ClassType', [p[1], []]]
  if gen_IR == 1:
    p[0] = p[1]

def p_388(p):
  'FieldAccess : Primary DOT IDENTIFIER '
  if type_check == 1:
    if p[1][0] != 'ClassType':
      print("Invalid Field Access!")
      sys.exit(-1)
    else:
      search_result = curr_table.lookup_class(p[1][1][0])
      #TODO: Currently looking only variables and arrays
      if p[3] in search_result.variables:
        p[0] = [search_result.variables[p[3]][0][0], [search_result.variables[p[3]][0][1], search_result.variables[p[3]][1]]]
      elif p[3] in search_result.arrays:
        p[0] = ['ArrayType', [search_result.arrays[p[3]][0], search_result.arrays[p[3]][1], search_result.arrays[p[3]][2]]]
      else:
        print("No class member named:", p[3])
        sys.exit(-1)
  if gen_IR == 1:
    if p[1][0] == 'curr_ref':
      parent_scope = curr_table.parent
      child_scope = curr_table
      class_scope = None
      while parent_scope != None:
        flag = 0
        for classes in parent_scope.classes:
          if parent_scope.classes[classes][1] == child_scope:
            #This is our target class
            class_name = classes
            class_scope = child_scope
            flag = 1
            break
        if flag == 1:
          break
        else:
          child_scope = parent_scope
          parent_scope = parent_scope.parent
      if p[3] in class_scope.variables:
        offset = class_scope.variables[p[3]][2]
        new_var = get_newvar()
        IR_list.append(IR("+INT", p[1][0], offset, new_var, curr_table))
        if class_scope.variables[p[3]][0][0] == 'PrimitiveType':
          p[0] = [new_var, class_scope.variables[p[3]][0][1]]
        else:
          p[0] = [new_var, 'CLASSREF']
      elif p[3] in class_scope.arrays:
        offset = class_scope.variables[p[3]][3]
        new_var = get_newvar()
        IR_list.append(IR("+INT", p[1][0], offset, new_var, curr_table))
        p[0] = [new_var, 'ARRAYREF']
      else:
        print("No member", p[3], "in class!") #Should never reach here

def p_389(p):
  'FieldAccess : SUPER DOT IDENTIFIER '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_390(p):
  'FieldAccess : temporary0 SUPER DOT IDENTIFIER '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_391(p):
  'ArrayAccess : ClassType LEFT_SQUARE Expression RIGHT_SQUARE '
  if type_check == 1:
    lookup_result = curr_table.lookup_array(p[1])
    if lookup_result[1] > 1:
      p[0] = ['ArrayType', [lookup_result[0], lookup_result[1] - 1, lookup_result[2]]]
    else:
      p[0] = [lookup_result[0][0], [lookup_result[0][1], lookup_result[2]]]
  if gen_IR == 1:
    p[0] = [p[1], [p[3]]]

def p_392(p):
  'ArrayAccess : PrimaryNoNewArray LEFT_SQUARE Expression RIGHT_SQUARE '
  if type_check == 1:
    if p[1][0] != 'ArrayType':
      print('Invalid Array Access!')
      sys.exit(-1)
    else:
      if p[1][1][1] > 1:
        p[0] = ['ArrayType', [p[1][1][0], p[1][1][1] - 1, p[1][1][2]]]
      else:
        p[0] = [p[1][1][0][0], [p[1][1][0][1], p[1][1][2]]]
  if gen_IR == 1:
    p[0] = [p[1][0], p[1][1] + [p[3]]]

def p_393(p):
  'MethodInvocation : IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
      lookup_result = curr_table.lookup_function(p[1])
      test = 0
      for function in lookup_result:
          if len(function[1]) != len(p[3]):
              continue
          check = 1
          for i in range(len(p[3])):
              if function[1][i][0] == "PrimitiveType" and p[3][i][0] == "PrimitiveType" and function[1][i][1] == p[3][i][1][0]:
                  continue
              elif function[1][i][0] == "ClassType" and p[3][i][0] == "ClassType" and function[1][i][1] == p[3][i][1][0]:
                  continue
              elif function[1][i][0] == "ArrayType" and p[3][i][0] == "ArrayType" and function[1][i][1] == p[3][i][1][0] and function[1][i][2] == p[3][i][1][1]:
                  continue
              else:
                  check = 0
                  break
          if check == 1:
              p[0] = function[0]
              test = 1
              break
          else:
              continue
      if test == 0:
          print("Invalid Arguments to function: ", p[1])
          sys.exit(-1)
  if gen_IR == 1:
    lookup_result = curr_table.lookup_function(p[1])
    test = 0
    target_function = None
    for function in lookup_result:
        if len(function[1]) != len(p[3]):
            continue
        check = 1
        for i in range(len(p[3])):
            if function[1][i][0] == "PrimitiveType" and function[1][i][1] == p[3][i][1]:
                continue
            elif function[1][i][0] == "ClassType" and p[3][i][1] == "CLASSREF":
                class_type, _ = curr_table.lookup_variable_noerror(p[3][i][0])
                if function[1][i][1] == class_type[0][1]:
                  continue
                else:
                  check = 0
                  break
            elif function[1][i][0] == "ArrayType" and p[3][i][1] == "ARRAYREF":
                array_type = curr_table.lookup_array(p[3][i][0])
                if function[1][i][1] == array_type[0]:
                  continue
                else:
                  check = 0
                  break
            else:
                check = 0
                break
        if check == 1:
            target_function = function
            test = 1
            break
    if target_function[0][1] == 'VOID':
      IR_list.append(IR("call", target_function[5], "", "", curr_table))
    else:
      new_var = get_newvar()
      IR_list.append(IR("=", "call", target_function[5], new_var, curr_table))
      p[0] = [new_var, target_function[0][1]]  

def p_394(p):
  'MethodInvocation : IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
      lookup_result = curr_table.lookup_function(p[1])
      test = 0
      for function in lookup_result:
        if len(function[1]) == 0:
          test = 1
      if test == 0:
        print("Invalid call to method", p[1])
        sys.exit(-1)
      else:
        p[0] = function[0]
  if gen_IR == 1:
    lookup_result = curr_table.lookup_function(p[1])
    target_function = None
    for function in lookup_result:
      if len(function[1]) == 0:
        target_function = function
        break 
    if target_function[0][1] == 'VOID':
      IR_list.append(IR("call", target_function[5], "", "", curr_table))
    else:
      new_var = get_newvar()
      IR_list.append(IR("=", "call", target_function[5], new_var, curr_table))
      p[0] = [new_var, target_function[0][1]] 

def p_395(p):
  'MethodInvocation : temporary0 IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
      lookup_result = curr_table.lookup_function(p[1]+p[2])
      test = 0
      for function in lookup_result:
          if len(function[1]) != len(p[4]):
              continue
          check = 1
          for i in range(len(p[4])):
              if function[1][i][0] == "PrimitiveType" and p[4][i][0] == "PrimitiveType" and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ClassType" and p[4][i][0] == "ClassType" and function[1][i][1] == p[4][i][1][0]:
                  continue
              elif function[1][i][0] == "ArrayType" and p[4][i][0] == "ArrayType" and function[1][i][1] == p[4][i][1][0] and function[1][i][2] == p[4][i][1][1]:
                  continue
              else:
                  check = 0
                  break
          if check == 1:
              p[0] = function[0]
              test = 1
              break
          else:
              continue
      if test == 0:
          print("Invalid Arguments to function: ", p[1]+p[2])
          sys.exit(-1)
  if gen_IR == 1:
    lookup_result = curr_table.lookup_function(p[1]+p[2])
    test = 0
    target_function = None
    for function in lookup_result:
        if len(function[1]) != len(p[4]):
            continue
        check = 1
        for i in range(len(p[4])):
            if function[1][i][0] == "PrimitiveType" and function[1][i][1] == p[4][i][1]:
                continue
            elif function[1][i][0] == "ClassType" and p[4][i][1] == "CLASSREF":
                class_type, _ = curr_table.lookup_variable_noerror(p[4][i][0])
                if function[1][i][1] == class_type[0][1]:
                  continue
                else:
                  check = 0
                  break
            elif function[1][i][0] == "ArrayType" and p[4][i][1] == "ARRAYREF":
                array_type = curr_table.lookup_array(p[4][i][0])
                if function[1][i][1] == array_type[0]:
                  continue
                else:
                  check = 0
                  break
            else:
              check = 0
              break
        if check == 1:
            target_function = function
            test = 1
            break
    if target_function[0][1] == 'VOID':
      IR_list.append(IR("call", target_function[5], "", "", curr_table))
    else:
      new_var = get_newvar()
      IR_list.append(IR("=", "call", target_function[5], new_var, curr_table))
      p[0] = [new_var, target_function[0][1]]  
              

def p_396(p):
  'MethodInvocation : temporary0 IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
      lookup_result = curr_table.lookup_function(p[1]+p[2])
      p[0] = lookup_result[0][0]
  if gen_IR == 1:
    lookup_result = curr_table.lookup_function(p[1]+p[2])
    target_function = None
    for function in lookup_result:
      if len(function[1]) == 0:
        target_function = function
        break 
    if target_function[0][1] == 'VOID':
      IR_list.append(IR("call", target_function[5], "", "", curr_table))
    else:
      new_var = get_newvar()
      IR_list.append(IR("=", "call", target_function[5], new_var, curr_table))
      p[0] = [new_var, target_function[0][1]] 

def p_397(p):
  'MethodInvocation : Primary DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
    if p[1][0] != 'ClassType':
      print("Invalid Field Access in Invocation of method ",p[1][1][0] + p[3])
      sys.exit(-1)
    else:
      fname = p[1][1][0] + p[3]
      lookup_result = curr_table.lookup_function(fname)
      test = 0
      for function in lookup_result:
          if len(function[1]) != len(p[5]):
              continue
          check = 1
          for i in range(len(p[5])):
              if function[1][i][0] == "PrimitiveType" and p[5][i][0] == "PrimitiveType" and function[1][i][1] == p[5][i][1][0]:
                  continue
              elif function[1][i][0] == "ClassType" and p[5][i][0] == "ClassType" and function[1][i][1] == p[5][i][1][0]:
                  continue
              elif function[1][i][0] == "ArrayType" and p[5][i][0] == "ArrayType" and function[1][i][1] == p[5][i][1][0] and function[1][i][2] == p[5][i][1][1]:
                  continue
              else:
                  check = 0
                  break
          if check == 1:
              p[0] = function[0]
              test = 1
              break
          else:
              continue
      if test == 0:
          print("Invalid Arguments to function: ", fname)
          sys.exit(-1)


def p_398(p):
  'MethodInvocation : Primary DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
    if p[1][0] != 'ClassType':
      print("Invalid Field Access in Invocation of method ",p[1][1][0] + p[3])
      sys.exit(-1)
    else:
      fname = p[1][1][0] + p[3]
      lookup_result = curr_table.lookup_function(fname)
      p[0] = lookup_result[0][0]

def p_399(p):
  'MethodInvocation : SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_400(p):
  'MethodInvocation : SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_401(p):
  'MethodInvocation : temporary0 SUPER DOT IDENTIFIER LEFT_PAREN ArgumentList RIGHT_PAREN '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_402(p):
  'MethodInvocation : temporary0 SUPER DOT IDENTIFIER LEFT_PAREN RIGHT_PAREN '
  if type_check == 1:
    print("Inheritence not supported!") #TODO: Support Inheritence
    sys.exit(-1)

def p_403(p):
  'ArgumentList : ArgumentList COMMA Expression '
  p[0] = p[1] + [p[3]]

def p_404(p):
  'ArgumentList : Expression '
  p[0] = [p[1]]

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
  if type_check == 1:
    for one_dim in p[3]: #DimExprs must be of Integer Type
      if one_dim[0] == 'PrimitiveType':
        if one_dim[1][0] in ['CHAR', "BYTE", 'SHORT', 'INT', 'LONG']:
          continue
        else:
          print("ArrayInit Expression must be an integer")
          sys.exit(0)
      else:
        print("ArrayInit Expression must be an integer")
        sys.exit(0)
    p[0] = ['ArrayType', [['PrimitiveType', p[2]], len(p[3]) + len(p[4]), []]]
  if gen_IR == 1:
    print("Partial array assignment not yet supported!")
    sys.exit(-1)

def p_411(p):
  'ArrayCreationExpression : NEW PrimitiveType DimExprs '
  if type_check == 1:
    for one_dim in p[3]: #DimExprs must be of Integer Type
      if one_dim[0] == 'PrimitiveType':
        if one_dim[1][0] in ['CHAR', "BYTE", 'SHORT', 'INT', 'LONG']:
          continue
        else:
          print("ArrayInit Expression must be an integer")
          sys.exit(0)
      else:
        print("ArrayInit Expression must be an integer")
        sys.exit(0)
    p[0] = ['ArrayType', [['PrimitiveType', p[2]], len(p[3]), []]]
  if gen_IR == 1:
    #Returns [Type, DimExprs]
    p[0] = [p[2], p[3]]


def p_412(p):
  'ArrayCreationExpression : NEW ClassType DimExprs Dims '
  if type_check == 1:
    for one_dim in p[3]: #DimExprs must be of Integer Type
      if one_dim[0] == 'PrimitiveType':
        if one_dim[1][0] in ['CHAR', "BYTE", 'SHORT', 'INT', 'LONG']:
          continue
        else:
          print("ArrayInit Expression must be an integer")
          sys.exit(0)
      else:
        print("ArrayInit Expression must be an integer")
        sys.exit(0)
    p[0] = ['ArrayType', [['ClassType', p[2]], len(p[3]) + len(p[4]), []]]
  if gen_IR == 1:
    print("Partial array assignment not yet supported!")
    sys.exit(-1)

def p_413(p):
  'ArrayCreationExpression : NEW ClassType DimExprs '
  if type_check == 1:
    for one_dim in p[3]: #DimExprs must be of Integer Type
      if one_dim[0] == 'PrimitiveType':
        if one_dim[1][0] in ['CHAR', "BYTE", 'SHORT', 'INT', 'LONG']:
          continue
        else:
          print("ArrayInit Expression must be an integer")
          sys.exit(0)
      else:
        print("ArrayInit Expression must be an integer")
        sys.exit(0)
    p[0] = ['ArrayType', [['ClassType', p[2]], len(p[3]), []]]
  if gen_IR == 1:
    p[0] = ['CLASSREF', p[3]]

def p_414(p):
  'ArrayCreationExpression : NEW PrimitiveType Dims ArrayInitializer '
  #TODO/ Shivam: what is ArrayInitializer doing here
  if type_check == 1:
    p[0] = ['ArrayType', [['PrimitiveType', p[2]], p[3], []]]
  if gen_IR == 1:
    p[0] = p[4]

def p_415(p):
  'ArrayCreationExpression : NEW ClassType Dims ArrayInitializer '
  #TODO/ Shivam: what is ArrayInitializer doing here
  if type_check == 1:
    p[0] = ['ArrayType', [['ClassType', p[2]], p[3], []]]
  if gen_IR == 1:
    p[0] = p[4]

def p_416(p):
  'DimExprs : DimExprs DimExpr '
  if type_check == 1:
    p[0] = p[1] + [p[2]]
  if gen_IR == 1:
    p[0] = p[1] + [p[2]]#shivam/TODO Not handled this, nextlist needs to be updated

def p_417(p):
  'DimExprs : DimExpr '
  if type_check == 1:
    p[0] = [p[1]]
  if gen_IR == 1:
    p[0] = [p[1]]

def p_418(p):
  'DimExpr : LEFT_SQUARE Expression RIGHT_SQUARE '
  if type_check == 1:
    p[0] = p[2]
  if gen_IR == 1:
    p[0] = p[2]

def p_419(p):
  'Expression : AssignmentExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_420(p):
  'Expression : LambdaExpression '
  if type_check == 1:
    print("LambdaExpressions not supported for now!")
    sys.exit(-1)

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
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_431(p):
  'AssignmentExpression : Assignment '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = [p[1],[]]

def p_432(p):
  'Assignment : LeftHandSide AssignmentOperator Expression '
  if type_check == 1:
    if p[2] in [">>=", "<<=", ">>>=", "&=", "^=", "|=", "%="]:
      #I Think both lefthandside and expression should be integers
      if p[1][0] != 'PrimitiveType' or p[3][0] != 'PrimitiveType':
        print(p[2],"can act only on integer types!")
        sys.exit(-1)
      else:
        if p[1][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG'] or p[3][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG']:
          print(p[2],"can act only on integer types!")
          sys.exit(-1)
        else:
          p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), p[1][1][1]]]
    elif p[2] in ["+=", '-=', "*=", "/="]:
      #I think lefthandside and righthandside should be realnumbers
      if p[1][0] != 'PrimitiveType' or p[3][0] != 'PrimitiveType':
        print(p[0],"can act only on Numeric types!")
        sys.exit(-1)
      else:
        if p[1][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG', 'FLOAT', 'DOUBLE', 'CHAR'] or p[3][1][0] not in ['INT', 'BYTE', 'SHORT', 'LONG', 'FLOAT', 'DOUBLE','CHAR']:
          print(p[2],"can act only on integer types!")
          sys.exit(-1)
        else:
          p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), p[1][1][1]]]#shivam: Here might be an error.It might accept a(int) += b(float)
    else:
      #Both must be type compatible:
      if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
        if biggest_real(p[1][1][0],p[3][1][0]) != p[1][1][0]:
          print("Error: Lossy conversion from ",p[3][1][0] ," to ",p[1][1][0])
          sys.exit(-1)
        p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), p[1][1][1]]] #shivam: Here might be an error.It might accept a(int) = b(float)
      elif p[1][0] == 'ArrayType' and p[3][0] == 'ArrayType':
        if p[1][1][1] == p[3][1][1] and p[1][1][0] == p[3][1][0]:
            p[0] = ['ArrayType', [p[1][1][0], p[3][1][0]]] #shivam: Looks here is an error
        else:
          print("Type mismatch in array assignment!")
          sys.exit(-1)
      elif p[1][0] == 'ClassType' and p[3][0] == 'ClassType' and p[3][1][0] == p[1][1][0]:
        p[0] = p[1]
      else:
        print("Type mismatch in assignment!")
        sys.exit(-1)
      #Handle EnumType
  

  if gen_IR == 1:
    global counter
    if type(p[3][1]) != type([]):
      if len(p[2]) == 1: # ASSIGN OPERATOR
        source2 = p[3][0]
        if p[1][1] != p[3][1]:
          source2 = "t_"+ str(counter)
          counter = counter + 1
          IR_list.append( IR("cast_to_"+p[1][1], p[3][0], "", source2, curr_table))
        instr = IR(p[2],source2,"",p[1][0], curr_table)
        IR_list.append(instr)
        p[0] = [p[1][0], p[1][1]] #shivam: It might be erroneous
      else:
        source1 = p[1][0]
        source2 = p[3][0]
        newtype = biggest_real(p[1][1], p[3][1])
        if p[1][1] != newtype:
          source1 = "t_"+ str(counter)
          counter = counter + 1
          IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
        if p[3][1] != newtype:
          source2 = "t_"+ str(counter)
          counter = counter + 1
          IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
        dest = "t_" + str(counter)
        counter = counter + 1
        IR_list.append(IR(p[2][:-1], source1, source2, dest, curr_table))
        IR_list.append(IR("=", dest, "", source1, curr_table))
        p[0] = [source1,newtype] #shivam: It might  be erroneous.
    else: #Handling array Creation
      new_var1 = get_newvar()
      IR_list.append(IR("+",p[1][0],8,new_var1, curr_table)) #Write field width
      IR_list.append(IR("=",get_primitive_type_size(p[3][0]),'',new_var1, curr_table))
      new_var2 = get_newvar()
      IR_list.append(IR("+",p[1][0],12,new_var2, curr_table)) #Write number of dimensions
      IR_list.append(IR("=",len(p[3][1]),'',new_var1, curr_table))
      new_var3 = get_newvar()
      IR_list.append(IR("=",1,"",new_var3, curr_table))
      counter_arr = 0
      for exp in p[3][1]: #Caloculate total number of elements and write each index max val
        new_var = get_newvar()
        IR_list.append(IR("=",exp[0],"",new_var, curr_table))
        new_var4 = get_newvar()
        IR_list.append(IR('*INT',new_var,new_var3,new_var4, curr_table))
        new_var3 = new_var4
        new_var5 = get_newvar()
        IR_list.append(IR("+",p[1][0],16+8*counter_arr,new_var5, curr_table))
        IR_list.append(IR("=",new_var,"", new_var5, curr_table))
        counter_arr = counter_arr + 1
      new_var6 = get_newvar()
      IR_list.append(IR('*INT',new_var3,get_primitive_type_size(p[3][0]),new_var6, curr_table))
      IR_list.append(IR('allocate_mem', new_var6, "", p[1][0], curr_table))
      p[0] = [p[1], 'ARRAYREF']

def p_433(p):
  'LeftHandSide : ClassType '
  if type_check == 1:
    if '.' not in p[1]:
      search_result, _ = curr_table.lookup_variable_noerror(p[1])
      if search_result != None:
        p[0] = [search_result[0][0],[search_result[0][1], search_result[1]]]
      else:
        search_result = curr_table.lookup_array(p[1])
        p[0] = ['ArrayType', [search_result[0], search_result[1], search_result[2]]]
    else:
      search_scope = curr_table.lookup_class_recursive(p[1])
      t = p[1].split('.')[-1]
      if t in search_scope.variables:
        p[0] = [search_scope.variables[t][0][0], [search_scope.variables[t][0][1], search_scope.variables[t][1]]]
      elif t in search_scope.arrays:
        temp = search_scope.arrays[t]
        p[0] = ['ArrayType', [temp[0], temp[1], temp[2]]]
      else:
        print(p[1],"Not in scope!")


  if gen_IR == 1: #Shivam: Requires Better handling
    if '.' not in p[1]:
      search_result,_ = curr_table.lookup_variable_noerror(p[1])
      if search_result != None:
        if search_result[0][0] == 'PrimitiveType':
          p[0] = [p[1], search_result[0][1]]
        else:
          p[0] = [p[1], 'CLASSREF']
      else:
        search_result = curr_table.lookup_array(p[1])
        p[0] = [p[1], 'ARRAYREF']
    else:
      name_split = p[1].split('.')
      new_var = get_newvar()
      IR_list.append(IR("=", name_split[0], "", new_var, curr_table))
      var_name = name_split[0]
      for i in range(1,len(name_split)):
        search_result, var_scope = curr_table.lookup_variable(var_name)
        class_scope = var_scope.lookup_class(search_result[0][1])
        offset = class_scope.variables[name_split[i]][2]
        new_var1 = get_newvar()
        IR_list.append(IR("+INT", new_var, offset, new_var1, curr_table))
        var_name = var_name + '.' + name_split[i]

      search_result,_ = curr_table.lookup_variable_noerror(p[1])
      if search_result != None:
        if search_result[0][0] == 'PrimitiveType':
          p[0] = [new_var1, search_result[0][1]]
        else:
          p[0] = [new_var1, 'CLASSREF']
      else:
        search_result = curr_table.lookup_array(p[1])
        p[0] = [new_var1, 'ARRAYREF']

def p_434(p):
  'LeftHandSide : FieldAccess '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_435(p):
  'LeftHandSide : ArrayAccess '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1: #No Bounds check as of now
    new_var = get_newvar()
    IR_list.append(IR("=", p[1][0], "", new_var, curr_table, comment = "Base pointer of array"))
    counter_arr = 0
    new_var2 = get_newvar()
    IR_list.append(IR("=",0,"",new_var2, curr_table, comment = "Offset from base"))
    stride_list = []
    counter_arr = 0
    for i in range(len(p[1][1])):
      new_var3 = get_newvar()
      IR_list.append(IR("+", p[1][0], 16+8*counter_arr, new_var3, curr_table))
      new_var4 = get_newvar()
      IR_list.append(IR("=", new_var3, "", new_var4, curr_table, comment = "Dimension %d limit" % (i)))
      stride_list.append(new_var4)
      counter_arr = counter_arr + 1
    new_var3 = get_newvar()
    IR_list.append(IR("=",1,"",new_var3, curr_table, comment = "Stride for dim 0"))

    for i in range(len(p[1][1])):
      index = len(p[1][1]) - i -1
      new_var5 = get_newvar()
      IR_list.append(IR("*INT",new_var3, p[1][1][index][0], new_var5, curr_table))
      new_var10 = get_newvar()
      IR_list.append(IR("+INT", new_var2, new_var5, new_var10, curr_table, comment = "Offset from base"))
      new_var2 = new_var10
      new_var4 = get_newvar()
      IR_list.append(IR("*INT", new_var3, stride_list[index], new_var4, curr_table, comment = "Stride for dim %d" % (i+1)))
      new_var3 = new_var4

    new_var7 = get_newvar()
    IR_list.append(IR("+INT", p[1][0], 8, new_var7, curr_table))
    new_var8 = get_newvar()
    IR_list.append(IR("=", new_var7, "", new_var8, curr_table, comment = "Width of each dimension."))
    new_var11 = get_newvar()
    IR_list.append(IR("*INT", new_var2, new_var8, new_var11, curr_table))
    addr = get_newvar()
    IR_list.append(IR("+INT", new_var, new_var11, addr, curr_table, comment = "Accessing memory"))
    var_type = curr_table.lookup_array(p[1][0])
    if var_type[0][0] == 'ClassType':
      p[0] = [addr, 'CLASSREF']
    else:
      p[0] = [addr, var_type[0][1]]

def p_436(p):
  'AssignmentOperator : ASSIGN '
  p[0] = '='

def p_437(p):
  'AssignmentOperator : MULASSN '
  p[0] = '*='

def p_438(p):
  'AssignmentOperator : DIVASSN '
  p[0] = '/='

def p_439(p):
  'AssignmentOperator : MODASSN '
  p[0] = '%='

def p_440(p):
  'AssignmentOperator : ADDASSN '
  p[0] = '+='

def p_441(p):
  'AssignmentOperator : SUBASSN '
  p[0] = '-='

def p_442(p):
  'AssignmentOperator : LSHIFTASSN '
  p[0] = '<<='

def p_443(p):
  'AssignmentOperator : RSHIFTASSN '
  p[0] = '>>='

def p_444(p):
  'AssignmentOperator : RRSHIFTASSN '
  p[0] = '>>>='

def p_445(p):
  'AssignmentOperator : ANDASSN '
  p[0] = '&='

def p_446(p):
  'AssignmentOperator : XORASSN '
  p[0] = '^='

def p_447(p):
  'AssignmentOperator : ORASSN '
  p[0] = '|='

def p_448(p):
  'ConditionalExpression : ConditionalOrExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_449(p):
  'ConditionalExpression : ConditionalOrExpression TERNARY Expression COLON ConditionalExpression '
  if type_check == 1:
    if p[1][0] != 'PrimitiveType' or p[1][1][0] != 'Boolean':
      print("Ternary Condition must be a boolean!")
      sys.exit(-1)
    #Shivam: Types of Expression and Conditional expression must be same/compatible (?)
    if p[3][0] == 'PrimitiveType' and p[5][0] == 'PrimitiveType':
      p[0] = ['PrimitiveType', [biggest_real(p[5][1][0], p[3][1][0]), []]]
    elif p[5][0] == 'ArrayType' and p[3][0] == 'ArrayType':
      if p[5][1][1] == p[3][1][1] and p[5][1][0] == p[3][1][0]:
        p[0] = ['ArrayType', [p[5][1][0], p[5][1][1],[]]]
      else:
        print("Type mismatch in array assignment!")
        sys.exit(-1)
    elif p[3][0] == 'ClassType' and p[5][0] == 'ClassType': #TODO: Same in Assignment
      if p[3][1][0] == p[5][1][0]:
        p[0] = ['ClassType', [p[5][1][0], []]]
      else:
        print("Incompatible class types!")
        sys.exit(0)
    elif p[3][0] == 'EnumType' and p[5][0] == 'EnumType':
      if p[3][1][0] == p[5][1][0]:
        p[0] = ['EnumType', [p[5][1][0], []]]
      else:
        print("Incompatible class types!")
        sys.exit(0)
    else:
      print("Type mismatch in assignment!")
      sys.exit(-1)

  if gen_IR == 1:
    print("No handling ternary case") #TODO?shivam : Will handle this after if else

def p_450(p):
  'ConditionalExpression : ConditionalOrExpression TERNARY Expression COLON LambdaExpression '
  if type_check == 1:
    print("Lambdas not supported yet!") #TODO: Support it!
    sys.exit(-1)

  if gen_IR == 1:
    print("Lambdas not supported yet!") #TODO: Support it!
    sys.exit(-1)

def p_451(p):
  'ConditionalOrExpression : ConditionalAndExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_452(p):
  'ConditionalOrExpression : ConditionalOrExpression Next BOR ConditionalAndExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[4][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' and p[4][1][0] == 'BOOLEAN': #Shivam: I think boolean operators can act on other PrimitiveTypes as well
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
      else:
        print("Boolean opeartors can act on booleans only!")
        sys.exit(-1)
    else:
      print("Boolean opeartors can act on booleans only!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    exp1_end = p[2]
    exp2_end = len(IR_list) - 1
    new_var = get_newvar()
    inst1 = IR("=", p[1][0], "", new_var, curr_table)
    new_label = get_newlabel()
    inst2 = IR("goto", "ifTrue", new_var, new_label, curr_table)
    IR_list = IR_list[:exp1_end+1] + [inst1, inst2] + IR_list[exp1_end+1:]
    inst3 = IR("=", p[4][0], "", new_var, curr_table)
    IR_list.append(inst3)
    IR_list.append(IR("label:", new_label, "","", curr_table))
    p[0] = [new_var, "BOOLEAN"]
    # global counter
    # new_var = "t_" + str(counter)
    # counter = counter + 1
    # IR_list.append(IR("=","true","",new_var,curr_table))
    # IR_list.append(IR("goto","","","if "+p[1][0],curr_table))
    # IR_list.append(IR("=",p[4][0],"",new_var,curr_table))
    # backpatch(p[1][2],p[2])
    # p[0] = [new_var, "BOOLEAN", p[4][2]+[len(IR_list)-2] ]

def p_453(p):
  'ConditionalAndExpression : InclusiveOrExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_454(p):
  'ConditionalAndExpression : ConditionalAndExpression Next BAND InclusiveOrExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[4][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' and p[4][1][0] == 'BOOLEAN': #Shivam: I think boolean operators can act on other PrimitiveTypes as well
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
      else:
        print("Boolean opeartors can act on booleans only!")
        sys.exit(-1)
    else:
      print("Boolean opeartors can act on booleans only!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    global IR_list
    exp1_end = p[2]
    exp2_end = len(IR_list) - 1
    new_var = get_newvar()
    inst1 = IR("=", p[1][0], "", new_var, curr_table)
    new_label = get_newlabel()
    inst2 = IR("goto", "ifFalse", new_var, new_label, curr_table)
    IR_list = IR_list[:exp1_end+1] + [inst1, inst2] + IR_list[exp1_end+1:]
    inst3 = IR("=", p[4][0], "", new_var, curr_table)
    IR_list.append(inst3)
    IR_list.append(IR("label:", new_label, "","", curr_table))
    p[0] = [new_var, "BOOLEAN"]
    # new_var = "t_" + str(counter)
    # counter = counter + 1
    # IR_list.append(IR("=","false","",new_var,curr_table))
    # IR_list.append(IR("goto","","","ifFalse "+p[1][0],curr_table))  
    # IR_list.append(IR("=",p[4][0],"",new_var,curr_table))
    # backpatch(p[1][2],p[2])
    # p[0] = [new_var, "BOOLEAN", [len(IR_list)-2] ] #shivam: Assumed InclusiveorExpression and later expression are just two-paired list(no bool)

def p_455(p):
  'InclusiveOrExpression : ExclusiveOrExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_456(p):
  'InclusiveOrExpression : InclusiveOrExpression LOR ExclusiveOrExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] and p[3][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
      else:
        print("Logical operation supported only on Integer Types!")
        sys.exit(-1)
    else:
      print("Logical operations supported only on Integer Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_457(p):
  'ExclusiveOrExpression : AndExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_458(p):
  'ExclusiveOrExpression : ExclusiveOrExpression LXOR AndExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] and p[3][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
      else:
        print("Logical operation supported only on Integer Types!")
        sys.exit(-1)
    else:
      print("Logical operations supported only on Integer Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_459(p):
  'AndExpression : EqualityExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_460(p):
  'AndExpression : AndExpression LAND EqualityExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] and p[3][1][0] in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
      else:
        print("Logical operation supported only on Integer Types!")
        sys.exit(-1)
    else:
      print("Logical operations supported only on Integer Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_461(p):
  'EqualityExpression : RelationalExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_462(p):
  'EqualityExpression : EqualityExpression EQUAL RelationalExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_463(p):
  'EqualityExpression : EqualityExpression NOTEQ RelationalExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_464(p):
  'RelationalExpression : ShiftExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_465(p):
  'RelationalExpression : RelationalExpression LT ShiftExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_466(p):
  'RelationalExpression : RelationalExpression GT ShiftExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_467(p):
  'RelationalExpression : RelationalExpression LTE ShiftExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_468(p):
  'RelationalExpression : RelationalExpression GTE ShiftExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] == 'BOOLEAN' or p[3][1][0] == 'BOOLEAN':
        print("Booleans are not comparable!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print("Comparison supported only on Numeric types!")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, "BOOLEAN"]

def p_469(p):
  'RelationalExpression : RelationalExpression INSTANCEOF ReferenceType '
  if type_check == 1:
    print("INSTANCEOF operator not yet supported!") #TODO: Support it!
    sys.exit(-1)

def p_470(p):
  'ShiftExpression : AdditiveExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_471(p):
  'ShiftExpression : ShiftExpression LSHIFT AdditiveExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] or p[3][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        print("Shifts supported only on real types")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
    else:
      print("Shifts supported only on primitive Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_472(p):
  'ShiftExpression : ShiftExpression RSHIFT AdditiveExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] or p[3][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        print("Shifts supported only on real types")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
    else:
      print("Shifts supported only on primitive Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_473(p):
  'ShiftExpression : ShiftExpression RRSHIFT AdditiveExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR'] or p[3][1][0] not in ['INT', 'SHORT', 'BYTE', 'LONG', 'CHAR']:
        print("Shifts supported only on real types")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
    else:
      print("Shifts supported only on primitive Types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_int(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_474(p):
  'AdditiveExpression : MultiplicativeExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_475(p):
  'AdditiveExpression : AdditiveExpression ADD MultiplicativeExpression '
  if type_check == 1:
    if p[1][0] == 'ClassType' and p[3][0] == 'ClassType':
      if p[1][1][0] == 'String' and p[3][1][0] == 'String':
        p[0] = ['ClassType', ['String', []]]
      else:
        print("Addition only supported on Numeric types or strings")
        sys.exit(-1)
    elif p[1][1][0] == 'String' and p[3][0] == 'PrimitiveType':
      p[0] = ['ClassType', ['String', []]]
    elif p[3][1][0] == 'String' and p[1][0] == 'PrimitiveType':
      p[0] = ['ClassType', ['String', []]]
    elif p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['BOOLEAN'] or p[3][1][0] in ['BOOLEAN']:
        print("Addition not supported on boolean types!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), []]]
    else: 
      print("Addition only supported on Numeric types or strings")
      sys.exit(-1)

  if gen_IR == 1:
    if p[1][1] in ["CLASSREF", "ARRAYREF", "STRING"] or p[3][1] in [ "CLASSREF", "ARRAYREF", "STRING"]:
      print("Handling IR generation of only primtive types in addition")
    else:
      global counter
      source1 = p[1][0]
      source2 = p[3][0]
      newtype = biggest_real(p[1][1], p[3][1])
      if p[1][1] != newtype:
        source1 = "t_"+ str(counter)
        counter = counter + 1
        IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
      if p[3][1] != newtype:
        source2 = "t_"+ str(counter)
        counter = counter + 1
        IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
      dest = "t_" + str(counter)
      counter = counter + 1
      IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
      p[0] = [dest, newtype]

def p_476(p):
  'AdditiveExpression : AdditiveExpression SUB MultiplicativeExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['BOOLEAN'] or p[3][1][0] in ['BOOLEAN']:
        print("Subtraction not supported on boolean types!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), []]]
    else: 
      print("Subtraction only supported on Numeric types")
      sys.exit(-1)

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_477(p):
  'MultiplicativeExpression : UnaryExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_478(p):
  'MultiplicativeExpression : MultiplicativeExpression MUL UnaryExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['BOOLEAN', 'CHAR'] or p[3][1][0] in ['BOOLEAN', 'CHAR']:
        print("Multiplication not supported on boolean or char types!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), []]]
    else: 
      print("Multiplication only supported on Integer types")

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_479(p):
  'MultiplicativeExpression : MultiplicativeExpression DIV UnaryExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['BOOLEAN', 'CHAR'] or p[3][1][0] in ['BOOLEAN', 'CHAR']:
        print("Divison not supported on boolean or char types!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_real(p[1][1][0], p[3][1][0]), []]]
    else: 
      print("Division only supported on Integer types")

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_480(p):
  'MultiplicativeExpression : MultiplicativeExpression MOD UnaryExpression '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType' and p[3][0] == 'PrimitiveType':
      if p[1][1][0] in ['BOOLEAN', 'CHAR', 'FLOAT', 'DOUBLE'] or p[3][1][0] in ['BOOLEAN', 'CHAR', 'FLOAT', 'DOUBLE']:
        print("Modulus not supported on boolean or floating types!")
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [biggest_int(p[1][1][0], p[3][1][0]), []]]
    else: 
      print("Modulus only supported on Integer types")

  if gen_IR == 1:
    global counter
    source1 = p[1][0]
    source2 = p[3][0]
    newtype = biggest_real(p[1][1], p[3][1])
    if p[1][1] != newtype:
      source1 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[1][0], "", source1, curr_table))
    if p[3][1] != newtype:
      source2 = "t_"+ str(counter)
      counter = counter + 1
      IR_list.append( IR("cast_to_"+newtype, p[3][0], "", source2, curr_table))
    dest = "t_" + str(counter)
    counter = counter + 1
    IR_list.append(IR(p[2]+newtype, source1, source2, dest, curr_table))
    p[0] = [dest, newtype]

def p_481(p):
  'UnaryExpression : PreIncrementExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_482(p):
  'UnaryExpression : PreDecrementExpression '
  if type_check == 1:
    p[0] = p[1]

  if gen_IR == 1:
    p[0] = p[1]

def p_483(p):
  'UnaryExpression : ADD UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Addition not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else:
      print("Addition only supported on primitive types")
      sys.exit(-1)
  if gen_IR == 1:
    if p[2][1] in ['BYTE','SHORT']:
      p[0] = [p[2][0], 'INT']
    else:
      p[0] = p[2]

def p_484(p):
  'UnaryExpression : SUB UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Subtraction not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else:
      print("Subtraction only supported on primitive types")
      sys.exit(-1)
  if gen_IR == 1:
    if p[2][1] in ['BYTE','SHORT']:
      new_var = get_newvar()
      IR_list.append(IR("*INT", p[2][0], -1, new_var, curr_table))
      p[0] = [new_var, 'INT']
    elif p[2][1] in ['LONG','INT']:
      new_var = get_newvar()
      IR_list.append(IR("*"+p[2][1], p[2][0], -1, new_var, curr_table))
      p[0] = [new_var, 'INT']
    else:
      new_var = get_newvar()
      IR_list.append(IR("*"+p[2][1], p[2][0], -1.0, new_var, curr_table))
      p[0] = [new_var, p[2][1]]

def p_485(p):
  'UnaryExpression : UnaryExpressionNotPlusMinus '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_486(p):
  'PreIncrementExpression : INC UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Decrement not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else:
      print("Decrement only supported on primitive types")
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR('+'+p[2][1], p[2][0], 1, new_var, curr_table))
    IR_list.append(IR('=',new_var,"",p[2][0], curr_table))
    p[0] = p[2]

def p_487(p):
  'PreDecrementExpression : DEC UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Decrement not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[2]
    else:
      print("Decrement only supported on primitive types")
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR('-'+p[2][1], p[2][0], 1, new_var, curr_table))
    IR_list.append(IR('=',new_var,"",p[2][0], curr_table))
    p[0] = p[2]

def p_488(p):
  'UnaryExpressionNotPlusMinus : PostfixExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_489(p):
  'UnaryExpressionNotPlusMinus : NEG UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType': #Shivam: Can Neg operator act on anything else?
      if p[2][1][0] in ['BOOLEAN', 'FLOAT', 'DOUBLE']:
        print("Non-Integer type cannot be nagated!") #Shivam: Can char type be negated?
        sys.exit(-1)
      else:
        p[0] = ['PrimitiveType', [p[2][1][0], []]]
    else:
      print(p[2][1][0],"Non-Integer be 'negated'")
      sys.exit(-1)
  if gen_IR == 1:
    if p[2][1] == 'CHAR':
      new_var1 = get_newvar()
      IR_list.append(IR("cast_to_INT", p[2][0], "", new_var1, curr_table))
      new_var2 = get_newvar()
      IR_list.append(IR("*INT",new_var1, -1, new_var2, curr_table))
      new_var3 = get_newvar()
      IR_list.append(IR("-INT",new_var2, -1, new_var3, curr_table))
      p[0] = [new_var3, "INT"]
    else:
      new_var2 = get_newvar()
      IR_list.append(IR("*"+p[2][1], p[2][0] , -1, new_var2, curr_table))
      new_var3 = get_newvar()
      IR_list.append(IR("-"+p[2][1], new_var2, -1, new_var3, curr_table))
      p[0] = [new_var3, p[2][1]]

def p_490(p):
  'UnaryExpressionNotPlusMinus : NOT UnaryExpression '
  if type_check == 1:
    if p[2][0] == 'PrimitiveType': #Shivam: Can Not operator act on anything else?
      p[0] = ['PrimitiveType', ['BOOLEAN', []]]
    else:
      print(p[2][1][0],"cannot be 'notted'")
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR("boolean_not",p[2][0],"",new_var, curr_table))
    p[0] = [new_var, "BOOL"]

def p_491(p):
  'UnaryExpressionNotPlusMinus : LEFT_PAREN PrimitiveType RIGHT_PAREN UnaryExpression '
  if type_check == 1:
    if p[4][0] == 'PrimitiveType': #TODO: Need Better type checking
      p[0] = ['PrimitiveType', [p[2], []]]
    else:
      print(p[4][1][0],"cannot be cast into",p[2])
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR("cast_to_"+p[2],p[4][0],"", new_var, curr_table))
    p[0] = [new_var, p[2]]

def p_492(p):
  'PostfixExpression : Primary '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_493(p):
  'PostfixExpression : PostFixType '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_494(p):
  'PostfixExpression : PostIncrementExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_495(p):
  'PostfixExpression : PostDecrementExpression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_496(p):
  'PostIncrementExpression : PostfixExpression INC '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Increment not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[1]
    else:
      print("Only Numeric Type can be incremented!")
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR("=",p[1][0],"",new_var, curr_table))
    IR_list.append(IR('+'+p[1][1],new_var, 1,p[1][0], curr_table))
    p[0] = [new_var, p[1][1]]

def p_497(p):
  'PostDecrementExpression : PostfixExpression DEC '
  if type_check == 1:
    if p[1][0] == 'PrimitiveType':
      if p[2][1][0] in ['BOOLEAN', 'CHAR']:
        print("Decrement not supported on boolean or char!")
        sys.exit(-1)
      else:
        p[0] = p[1]
    else:
      print("Only Numeric Type can be decremented!")
      sys.exit(-1)
  if gen_IR == 1:
    new_var = get_newvar()
    IR_list.append(IR("=",p[1][0],"",new_var, curr_table))
    IR_list.append(IR('-'+p[1][1],new_var, 1,p[1][0], curr_table))
    p[0] = [new_var, p[1][1]]

def p_498(p):
  'ConstantExpression : Expression '
  if type_check == 1:
    p[0] = p[1]
  if gen_IR == 1:
    p[0] = p[1]

def p_499(p):
  'New_Scope :'
  global next_num
  global curr_table
  if gen_symbol_table == 1:
    new_table = symbol_table(next_num, curr_table)
    table_list.append(new_table)
    curr_table.child.append(new_table)
    curr_table = new_table
    next_num+=1 
  elif gen_IR == 1:
    curr_table = table_list[next_num]
    next_num += 1
    p[0] = len(IR_list)
  else:
    curr_table = table_list[next_num]
    next_num += 1

def p_500(p):
  'Next :'
  if gen_IR == 1:
    p[0] = len(IR_list) - 1

def p_501(p):
  'Gen_Next :'
  if gen_IR == 1:
    p[0] = len(IR_list) - 1

def p_502(p):
  'Gen_If :'
  if gen_IR == 1:
    p[0] = len(IR_list) - 1


def p_error(p):
  print(p)
  print("Syntax error in input!")
  sys.exit(-1)

if __name__ == '__main__':
  lexer = lex.lex(module = lexer)
  parser = yacc.yacc(start = 'CompilationUnit')
  in_file = open(sys.argv[1], 'r')
  data = in_file.read()
  in_file.close()
  gen_symbol_table = 1
  curr_table = symbol_table(next_num, None)
  next_num = 1 
  special_scope = symbol_table(next_num, curr_table) #Special scope for inbuilt data type
  curr_table.child.append(special_scope)
  next_num = 2
  table_list.append(curr_table)
  table_list.append(special_scope)
  curr_table.add_classes("String", special_scope)
  result = parser.parse(data)
  table_list[0].patch_table_sanity_check()
  print("GENERATED SYMBOL TABLE:")
  curr_table.preety_print(0)
  curr_table = table_list[0]
  next_num = 2
  gen_symbol_table = 0
  type_check = 1
  result = parser.parse(data)
  curr_table = table_list[0]
  next_num = 2
  type_check = 0
  gen_IR = 1
  result = parser.parse(data)
  print()
  print("GENERATED IR CODE:")
  table_list[0].print_IR()
