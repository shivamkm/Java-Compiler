import sys
import random
'''
                      OFFICIAL DOCUMENTATION:
-- A symbol table is implemented as a class.
-- variables, functions/constructors, classes and arrays are stored in separate dictionaries
-- Parent is symbol_table class one level above
-- Child are all symbol_tables below it
-- Each symbol table has a UID 'number'
-- name of any kind is just a string
-- Type of any kind (var_type, ret_type, ....) is a two membered list:
        Member1: PrimitiveType, ArrayType, ClassType
        Member2: Typename
                For PrimitiveType, Typename = INT, SHORT, BYTE, .... (Treat void as Primitive Type)
                For ArrayType, Typename = Type (i.e. a two membered list same as this)
                For ClassType, Typename = Name of Class
-- modifier is a list of modifiers example: [public, static]
-- array_num_dims is just a number -> How many dimensions does this array have?
-- argument_list -> List of Types (Type is a 2-membered list explained above)
'''
class symbol_table:
	def __init__(self, number, parent):
		self.number = number   #Identifier number for this table
		self.parent = parent   #Symbol table above this table, None for root table
		self.size = 0          #Total memory size required by declarations in this scope 
		self.child = []        #All tables under its scope
		self.variables  = {}   #A dictionary of all vriables defined in this scope
		self.functions  = {}   #A dictionary of functions in this scope
		self.classes    = {}   #A dictionary of classes in this scope
		self.arrays     = {}   #A dictionary of all arrays defined in this scope
		self.enums      = {}   #A dictionary of all enums defined in this scope
		self.interfaces = {}   #A dictionary of all intefaces defined in the scope
		self.scope_init = []
		self.scope_name = ""

	def already_used(self, name, is_function = 0):
		curr_level = self
		while curr_level != None:
			if name in curr_level.variables:
				print("SCOPE ERROR: ",name,"already defined in scope!")
				sys.exit(-1)
			elif name in curr_level.functions:
				if is_function == 1:  #To support function polymorphism
					return [curr_level.functions[name], 'F']
				else:
					print("SCOPE ERROR: ",name,"already defined in scope!")
					sys.exit(-1)
			elif name in curr_level.classes:
				if is_function == 1:  #To support constructors, maybe we should additionary check if the definition was 1 level above
					return [curr_level.classes[name], 'C']
				else:
					print("SCOPE ERROR: ",name,"already defined in scope!")
					sys.exit(-1)
			elif name in self.arrays:
				print("SCOPE ERROR: ",name,"already defined in scope!")
				sys.exit(-1)
			elif name in self.enums:
				print("SCOPE ERROR: ",name,"already defined in scope!")
				sys.exit(-1)
			elif name in self.interfaces:
				print("SCOPE ERROR: ",name,"already defined in scope!")
				sys.exit(-1)
			curr_level = curr_level.parent
			break#shivam TODO: Outer scope cases need to be checked for all cases
		return None #To name clash found

	def lookup_class(self, class_name): #Returns the definition scope of given class name, no dots in name allowed
		name_split = class_name.split('.')
		if len(name_split) == 1:
			curr_scope = self
			while curr_scope != None:
				if class_name in curr_scope.classes:
					return curr_scope.classes[class_name][1]
				else:
					curr_scope = curr_scope.parent
			print("Class:", class_name,"not defined in scope")
			sys.exit(-1)
		else:
			final_scope = lookup_class_recursive(class_name)
			if name_split[-1] in final_scope.classes:
				return final_scope.classes[name_split[-1]][1]
			else:
				print("SCOPE ERROR:", class_name, "not in scope!")
				sys.exit(-1)

	def lookup_variable(self, var_name): #Returns the type of variable
		name_split = var_name.split('.')
		if len(name_split) == 1:
			curr_scope = self
			while curr_scope != None:
				if var_name in curr_scope.variables:
					return [curr_scope.variables[var_name], curr_scope]
				else:
					curr_scope = curr_scope.parent
			print("SCOPE ERROR: Variable",var_name,"not in scope!")
			sys.exit(-1)
		else:
			final_scope = lookup_class_recursive(var_name)
			if name_split[-1] in final_scope.variables:
				return [final_scope.variables[name_split[-1]], final_scope]
			else:
				print("SCOPE ERROR:", var_name, "not in scope!")
				sys.exit(-1)

	def lookup_variable_noerror(self, var_name): #Returns the type of variable
		name_split = var_name.split('.')
		if len(name_split) == 1:
			curr_scope = self
			while curr_scope != None:
				if var_name in curr_scope.variables:
					return [curr_scope.variables[var_name], curr_scope]
				else:
					curr_scope = curr_scope.parent
			return [None, None]
		else:
			final_scope = self.lookup_class_recursive(var_name)
			if name_split[-1] in final_scope.variables:
				return [final_scope.variables[name_split[-1]], final_scope]
			else:
				return [None, None]

	def lookup_variable_nonrec(self, var_name): #Lookup variable name with current scope only
		if var_name in self.variables:
			return self.variables[var_name][0]
		else:
			print("SCOPE: Variable", var_name,"not in scope")
			sys.exit(-1)

	def lookup_array(self, var_name):
		name_split = var_name.split('.')
		if len(name_split) == 1: #name should be a part of array list somewhere
			curr_scope = self
			while curr_scope != None:
				if name_split[0] in curr_scope.arrays:
					return curr_scope.arrays[name_split[0]]
				else:
					curr_scope = curr_scope.parent
			print("SCOPE ERROR: Array", name_split[0], "not in scope")
			sys.exit(-1)
		else:
			final_scope = self.lookup_class_recursive(var_name)
			if name_split[-1] in final_scope.arrays:
				return final_scope.arrays[name_split[-1]]
			else:
				print("SCOPE ERROR:", var_name, "not in scope!")
				sys.exit(-1)

	def lookup_array_noerror(self, var_name):
		name_split = var_name.split('.')
		if len(name_split) == 1: #name should be a part of array list somewhere
			curr_scope = self
			while curr_scope != None:
				if name_split[0] in curr_scope.arrays:
					return curr_scope.arrays[name_split[0]]
				else:
					curr_scope = curr_scope.parent
			return None
		else:
			final_scope = self.lookup_class_recursive(var_name)
			if name_split[-1] in final_scope.arrays:
				return final_scope.arrays[name_split[-1]]
			else:
				return None

	def lookup_function(self, var_name):
            name_split = var_name.split('.')
            if len(name_split) == 1: 
                    curr_scope = self
                    while curr_scope != None:
                            if name_split[0] in curr_scope.functions:
                                    return curr_scope.functions[name_split[0]]
                            else:
                                    curr_scope = curr_scope.parent
                    print("SCOPE ERROR: Function ", name_split[0], "not in scope")
                    sys.exit(-1)
            else:
                    final_scope = self.lookup_class_recursive(var_name)
                    if name_split[-1] in final_scope.functions:
                            return final_scope.functions[name_split[-1]]
                    else:
                            print("SCOPE ERROR: Function ", var_name, "not in scope!")
                            sys.exit(-1)

	def lookup_function_noerror(self, var_name):
            name_split = var_name.split('.')
            if len(name_split) == 1: 
                    curr_scope = self
                    while curr_scope != None:
                            if name_split[0] in curr_scope.functions:
                                    return curr_scope.functions[name_split[0]]
                            else:
                                    curr_scope = curr_scope.parent
                    return None
            else:
                    final_scope = self.lookup_class_recursive(var_name)
                    if name_split[-1] in final_scope.functions:
                            return final_scope.functions[name_split[-1]]
                    else:
                            return None

	def lookup_class_recursive(self, var_name): #recursive class loopkup, returns final class scope
		name_split = var_name.split('.')
		var_type, curr_scope = self.lookup_variable(name_split[0])
		if var_type[0][0] != 'ClassType':
			print(name_split[0],"is not a class")
			sys.exit(0)
		curr_scope = curr_scope.lookup_class(var_type[0][1])
		for i in range(1,len(name_split)-1):
			var_type = curr_scope.lookup_variable_nonrec(name_split[i])
			if var_type[0] != 'ClassType':
				print(name_split[i],"is not a member of class",name_split[i-1])
				sys.exit(-1)
			curr_scope = curr_scope.lookup_class(var_type[1])
		return curr_scope

	def add_variables(self, var_name, var_type, width, modifiers):
		#For a class we store it's pointer on heap
		if self.already_used(var_name) == None:
			#[Type, modifier, offset, width]
			self.variables[var_name] = [var_type, modifiers, self.size, width]
			self.size = self.size + width

	def print_IR(self):
		if len(self.scope_init) > 0:
			print("ScopeInit", self.scope_name)
			for ins in  self.scope_init:
				print(" "*4, ins)
		for name in self.functions:
			for one_func in self.functions[name]:
				print("Method",one_func[5],"(",name,"):")
				for ins in one_func[6]:
					print(" "*4, ins)
		for c in self.child:
			c.print_IR()

	def add_enums(self, enum_name, enum_list, modifiers):
		if self.already_used(enum_name) == None:
			self.enums[enum_name] = [enum_list, modifiers]

	def add_functions(self, func_name, ret_type, argument_list, child_scope, is_constructor = 0, modifiers=[]):
            prev_decl = self.already_used(func_name, is_function = 1)
            if prev_decl == None: #No name clash in current scope
                    self.functions[func_name] = [[ret_type, argument_list, is_constructor, modifiers, child_scope]]
            else:
                    if func_name in self.functions and prev_decl[1] == 'F': #Clash in current scope append to list
                            for functions in prev_decl[0]:
                                if functions[1] == argument_list:
                                    print("SCOPE ERROR: ", func_name, " already defined in scope")
                                    sys.exit(-1)
                            self.functions[func_name].append([ret_type, argument_list, is_constructor, modifiers, child_scope])
                    else: #Clash in some outer scope or with a class, current scope list is empty
                            self.functions[func_name] = [[ret_type, argument_list, is_constructor, modifiers, child_scope]]

	def add_classes(self, class_name, child_scope, modifiers=[]):
		if self.already_used(class_name) == None:
			self.classes[class_name] = [modifiers, child_scope] #Keeping track of this class's sub-scope

	def add_interfaces(self, interface_name, child_scope, modifiers):
		if self.already_used(interface_name) == None:
			self.interfaces[interface_name] = [modifiers, child_scope] #Keeping track of this interface's sub-scope

	def add_arrays(self, array_name, array_type, array_num_dims, modifiers):
		if self.already_used(array_name) == None:
			self.arrays[array_name] = [array_type, array_num_dims, modifiers, self.size, 16+8*array_num_dims]
			self.size = self.size + 16+8*array_num_dims
	#For array we will store, 8 byte pointer, 4 byte type_width, 4 byte_num_dim and for each dim, 8-byte max permissible index

	def preety_print(self, indentation):
		children = [i for i in self.child]
		for key in self.variables:
			print(' '*indentation+'VARIABLE:',key,"| Type:",self.variables[key][0][1],"| Modifiers:", self.variables[key][1])
		for key in self.arrays:
			print(' '*indentation+'ARRAY:',key,"| Type:",self.arrays[key][0][1],"| Dimensions:", self.arrays[key][1],"| Modifiers:", self.arrays[key][2])
		for key in self.classes:
			print(' '*indentation+'CLASS:',key,"| Modifiers:", self.classes[key][0])
			self.classes[key][1].preety_print(indentation+2)
			children.remove(self.classes[key][1])
		for key in self.interfaces:
			print(' '*indentation+'INTERFACE:',key,"| Modifiers:",self.interfaces[key][0])
			self.interfaces[key][1].preety_print(indentation+2)
			children.remove(self.interfaces[key][1])
		for key in self.functions:
			for one_func in self.functions[key]:
				if one_func[2] == 1:
					print(' '*indentation + "CONSTRUCTOR:", key,"(",one_func[5],")", "| Arguments:",end = " ")
					for arg in one_func[1]:
						if arg[0] == 'ArrayType':
							print("Array_of_type_"+arg[1][1]+"_dimension_"+str(arg[2]), end = " ")
						else:
							print(arg[1],end=" ")
					print("| Modifiers:", one_func[3])
				if one_func[2] == 0:
					print(' '*indentation + "FUNCTION:", key,"(",one_func[5],")", "| Return Type:", one_func[0][1], "| Arguments:",end = " ")
					for arg in one_func[1]:
						if arg[0] == 'ArrayType':
							print("Array_of_type_"+arg[1][1]+"_dimension_"+str(arg[2]), end = " ")
						else:
							print(arg[1],end=" ")
					print("| Modifiers:", one_func[3])
				one_func[4].preety_print(indentation+2)
				children.remove(one_func[4])
		for key in self.enums:
			print(' '*indentation+'ENUM:',key,"| Possible Values:", self.enums[key][0],"| Modifiers:",self.enums[key][1])
		for tables in children:
			tables.preety_print(indentation+2)

	def lookup_class_noerror(self, class_name): #Returns the definition scope of given class name, no dots in name allowed
		curr_scope = self
		while curr_scope != None:
			if class_name in curr_scope.classes:
				return curr_scope.classes[class_name][1]
			else:
				curr_scope = curr_scope.parent
		return None

	def lookup_enum_noerror(self, enum_name): #Return enum definition. No dots allowed in name
		curr_scope = self
		if '.' in enum_name:
			return None
		while curr_scope != None:
			if enum_name in curr_scope.enums:
				return curr_scope.enums[enum_name]
			else:
				curr_scope = curr_scope.parent
		return None

	def patch_table_sanity_check(self):
		for var in self.classes:
			self.classes[var][1].scope_name = "ctor_" + var + "_" + str(random.randint(1,100000))
		for var in self.variables:
			if self.variables[var][0][0] == 'ClassType':
				if self.lookup_class_noerror(self.variables[var][0][1]) == None:
					if self.lookup_enum_noerror(self.variables[var][0][1]) == None:
						print("No Type named:", self.variables[var][0][1])
						sys.exit(-1)
					else:
						self.variables[var] = [['EnumType', self.variables[var][0][1]], self.variables[var][1]]
		for var in self.arrays:
			if self.arrays[var][0][0] == 'ClassType':
				if self.lookup_class_noerror(self.arrays[var][0][1]) == None:
					if self.lookup_enum_noerror(self.arrays[var][0][1]) == None:
						print("No Type named:", self.arrays[var][0][1])
						sys.exit(-1)
					else:
						self.arrays[var] = [['EnumType', self.arrays[var][0][1]], self.arrays[var][1], self.arrays[var][2]]
		for var in self.functions:
			for i in range(len(self.functions[var])):
				self.functions[var][i].append(var+str(random.randint(1,100000000)))
				if self.functions[var][i][2] == 1:
					continue
				if self.functions[var][i][0][0] == 'ClassType':
					if self.lookup_class_noerror(self.functions[var][i][0][1]) == None:
						if self.lookup_enum_noerror(self.functions[var][i][0][1]) == None:
							print("No Type named:", self.functions[var][i][0][1])
							sys.exit(-1)
						else:
							self.functions[var][i] = [['EnumType', self.functions[var][i][0][1]], self.functions[var][i][1], self.functions[var][i][2], self.functions[var][i][3], self.functions[var][i][4]]
		for c in self.child:
			c.patch_table_sanity_check()

