import sys
import os

fhand = open("Grammar", "r")
current_name = ""
for line in fhand:
    l = line.strip().split()
    if len(l) > 0:
        if l[1].strip() == ":" :
            print()
    print(line.strip())
    if len(l) > 1:
        if l[1].strip() == ":" :
            current_name = l[0].strip()
            num_arguments = len(l) - 2
            print("{")
            if num_arguments == 1 and not l[2].strip().isupper():
                print("  $$ = $1;")
            else:
                print("  $$ = (char*)malloc(64);")
                print("  snprintf($$, 64, \"%s_nikhild\", counter);" % current_name)
                print("  counter++;")
                for i in range(num_arguments):
                    if l[2+i].strip().isupper():
                        print("  fprintf(outfile, \"label_nikhild [label = \\\"shivam\\\"]\\n\", label_counter, $%d);" % (i+1))
                        print("  fprintf(outfile, \" shivam -> label_nikhild\\n\", $$, label_counter);")
                        print("  label_counter++;")
                    else:
                        print("  fprintf(outfile, \"shivam -> shivam\\n\", $$, $%d);" % (i+1))
                        # print("  cout << $$ << \" -> \" << $%d << endl;" % (i+1))
            print("}")
        elif l[0].strip() == "|":
            if l[1].strip() == "%empty":
                print("{")
                print("  Enter Rule Here")
                print("}")
            else:
                num_arguments = len(l) - 1
                print("{")
                if num_arguments == 1 and not l[1].strip().isupper():
                    print("  $$ = $1;")
                else:
                    print("  $$ = (char*)malloc(64);")
                    print("  snprintf($$, 64, \"%s_nikhild\", counter);" % current_name)
                    print("  counter++;")
                    for i in range(num_arguments):
                        if l[1+i].strip().isupper():
                            print("  fprintf(outfile, \"label_nikhild [label = \\\"shivam\\\"]\\n\", label_counter, $%d);" % (i+1))
                            print("  fprintf(outfile, \"shivam -> label_nikhild\\n\", $$, label_counter);")
                            print("  label_counter++;")
                        else:
                            print("  fprintf(outfile, \"shivam -> shivam\\n\", $$, $%d);" % (i+1))
                            # print("  cout << $$ << \" -> \" << $%d << endl;" % (i+1))
                print("}")

fhand.close()
