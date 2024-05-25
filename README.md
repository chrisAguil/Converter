# Converter
In teams:

Make use of reactive programming in R to create a Shiny app that converts a regular grammar into a finite automaton.
Check the presentation "2.4 Regular Grammars.pptx" on how to convert a regular grammar into an automaton.
The user interface needs to include a text area (textAreaInput) where the user can type a regular grammar.
The user interface needs to have a section where the corresponding automaton is displayed.
While the user types in a grammar, the program shows the corresponding automaton in real time.
The grammar input format is X -> Y where X is the antecedent and Y is the consequent. Examples: S -> aA, A -> bB, B -> z.
The initial state is denoted with S. In the automaton diagram the initial state S needs to be green colored.
The final state Z needs to be colored in red.
 

Example user input:

S -> aA
S -> bA
A -> aB
A -> bB
A -> a
B -> aA
B -> bA

Example output:

![image](https://github.com/chrisAguil/Converter/assets/135066306/a8c18e4d-ca21-49f4-af72-6ebce03ff07b)

In the example above, the initial state is marked with an arrow. In your program, the initial node should be colored in green. The final state in the above example is depicted with two circles. In your program it needs to b colored in red.

The following video shows how your program should look like. The "Output" section can be omitted. It was included for debugging purposes.
