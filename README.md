# MagicInputParser
Matlab inputParser class plus fancy magic features that reduce typing.

We like the Matlab [inputParser](http://www.mathworks.com/help/matlab/ref/inputparser-class.html) class.  It makes argument processing more declarative and more convenient.

It helps us adopt a consistent and maintainable style of parsing where:
 - Required arguments are positional and come first.
 - Non-Required arguments are name-value that can be given in any order.
 - There is no such thing as an optional, positional argument.
 
# Limitations
But the stock inputParser() from Matlab falls short in some ways. For example, to get parsing results into the function workspace we have to do a lot of typing for each input we must:
 - declare the argument in the function declaration
 - declare the argument to the input parser
 - pass the argument to the parser's parse() method
 - find the parsed value in the parser's Results field
 - assign the value to a variable in the workspace

So, we have to type the name of each variable 5 times!  Or, we have to let the parser's Results field invade the rest of our code. That's not a nice choice.

# Goals
This MagicInputParser will extend the stock inputParser to make it more fun to use and easier to integrate with new and existing projects.

This is a work in progress.  Goals include:
 - Should not have to pass arguments to parse().  Rather, magically reach back to caller to get input variables by name by name.
 - Should not have to dig out parser.Results and assign to workspace.  Should be able to assign automatically to the calling workspace or an an existing struct or object.
 - Be able to declare a named parameter that's also a Matlab preference.  Use the preference value as parameter the default, if it's available.
   - `parser.addPreference('prefGroup', 'prefName', 'defaultValue', @validator)`
 - When parsing for class methods, want to make it easy for all public properties to be parameters.  What this to be dynamic and reflective, so as to capture superclass parameters.  Property defaults can be the current values.  
   - Object property validators would be hard to declare in this way.  This is OK because objects should use set.foo in the first place.  There's no benefit to reproducing this mechanism in the parser code.
 - Extend declarations like addRequired(), addParameter(), addPreference(), add to accept documentation strings.
 - Pretty-print human-readable documentation from declarations.
