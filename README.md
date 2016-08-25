# MagicInputParser
Matlab inputParser class plus fancy magic features that reduce typing.

We like the Matlab [inputParser](http://www.mathworks.com/help/matlab/ref/inputparser-class.html) class.  It makes argument processing more declarative and more convenient.

It helps us adopt a consistent and maintainable convention for parsing where:
 - Required arguments are positional and come first.
 - Non-Required arguments are name-value pairs that can be given in any order or omitted to accept defaults.
 - There is no such thing as an optional, positional argument.
 
# inputParser Limitations
But the stock inputParser() from Matlab falls short in some ways. For example, to get parsing results into the function workspace we have to do a lot of typing.  For each input we must:
 - declare the argument in the function declaration
 - declare the argument to the input parser
 - pass the argument to the parser's parse() method
 - find the parsed value in the parser's Results field
 - assign the value to a variable in the workspace

So, we have to type the name of each variable five times!  Or, we have to type each name three times and let the parser's Results field invade the rest of our code. That's not a nice choice.

# Features
The MagicInputParser extends the stock inputParser to make it more fun to use and easier to integrate with new and existing projects.

Here are some code examples.

## Don't pass arguments to parse()
Once you've declared inputs to the parser, you should not have to type their names again when calling the `parse()` method.  This is tedious and error-prone.  The parser can figure it out for you. 

```
function myFunction(foo, varargin)

parser = MipInputParser();
parser.addRequired('foo', @isnumeric);
parser.addParameter('quux', 'aaa', @ischar);

parser.parseMagically('caller');
disp(foo)
disp(quux)
```

## Don't dig out Results
Likewise, after calling parse(), you should not have to rummage around in the `parser.Results` to get the parsed values.  The parser can figure this out for you.

The parser can assign parsed values directly to your calling workspace:
```
parser.parseMagically('caller');
disp(foo)
disp(quux)
```

Or to a struct that you pass in:
```
myStruct = parser.parseMagically(myStruct);
disp(myStruct.foo)
disp(myStruct.quux)
```

Or to an object that you pass in:
```
parser.parseMagically(myObject);
disp(myObject.foo)
disp(myObject.quux)
```

## Declare all object properties as named parameters.
In class constructors and the like, you should be able to pass in any public property as a named parameter.  The parser can figure out what all the public properties are, including properties of superclasses, and make these available as named parameters.

```
properties
    foo;
    quux;
end

methods
    function myObject = MyConstructor(varargin)
        parser = MipInputParser();
        parser.addProperties(myObject);
        parser.parseMagically(myObject);

        parser.parseMagically(myObject);
        disp(myObject.foo)
        disp(myObject.quux)
    end
end
```

## Declare a named parameter that's also a Matlab preference.
Sometimes the default value of a named parameter should come from a Matlab preference.  The MagicInputParser has a convenient syntax for this.

You might have a preference like this:
```
setpref('MipTests', 'quux', 'swingle');
```

You could use the preference value as a default like this:
```
function myFunction(varargin)
parser = MipInputParser();
parser.addPreference('MipTests', 'quux', 'fallback-if-preference-not-set', @ischar);

parser.parseMagically('caller');
disp(quux);
```

## Check that a value belongs to a set.
The MagicInputParser has a convenient syntax for validating that an input value belongs to a set of values.  It's a utility method that returns an anonymous validation function.

```
parser = MipInputParser();
parser.addRequired('foo', parser.isAny(77, 'cheese', {}, struct()));
```


# TODO
The MagicInputParser is a work in progress.  Here are some outstanding goals:
- Extend declarations like addRequired(), etc. to accept documentation strings.
- Pretty-print human-readable documentation from declarations.
- Support sets of parameters that we want to reuse throughout a project.  To key parts will be:
   - a way to declare/maintain the parameter set in one place, and use it from many places
   - a concise way to pass parsed parameter sets between functions, for example from a wrapper function to a delegate, without having to touch all the individual parameters.
