./parser --inp $1.java --out temp.dot
dot -Tpng temp.dot -o $1.png
rm temp.dot
