import sys
'''
Class to represent one instruction in Intermediate Code
'''

class IR:
	def __init__(self, opcode, source1, source2, destination, scope, comment = ""): #All the arguments are strings
		self.opcode      = opcode
		self.source1     = source1
		self.source2     = source2
		self.destination = destination
		self.scope       = scope
		self.comment     = comment

	def __str__(self):
		ret_val = ""
		if self.opcode == '=':
			ret_val =  self.destination + " " + self.opcode + " " + str(self.source1) + " " + str(self.source2)
		elif self.opcode == 'allocate_mem':
			ret_val =  self.destination + " = allocate_mem " + str(self.source1)
		elif self.opcode == 'goto':
			ret_val = "goto " + str(self.destination) + " " + self.source1 + " " + self.source2
		elif self.opcode == 'label:':
			ret_val = 'label: ' + self.source1
		elif self.opcode == 'return':
			ret_val = 'return ' + str(self.source1)
		elif self.opcode == 'call':
			ret_val = 'call ' + self.source1
		else:
			ret_val = self.destination + " = " + str(self.source1) + " " + self.opcode + " " + str(self.source2)
		if self.comment == "":
			return ret_val
		else:
			return ret_val + " "*10 + "#" + self.comment 