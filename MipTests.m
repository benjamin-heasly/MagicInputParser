classdef MipTests < matlab.unittest.TestCase
    
    properties
        foo;
        quux;
    end
    
    methods (Test)
        
        function testParseToWorkspace(obj)
            parser = MipInputParser();
            parser.addRequired('foo', @isnumeric);
            parser.addParameter('quux', '4', @ischar);
            
            foo = 2;
            varargin = {'quux', 'swingle'};
            parser.parseMagically('caller');
            
            obj.assertEqual(foo, 2);
            obj.assertEqual(quux, 'swingle');
        end
        
        function testParseToStruct(obj)
            parser = MipInputParser();
            parser.addRequired('foo', @isnumeric);
            parser.addParameter('quux', '4', @ischar);
            
            foo = 2;
            varargin = {'quux', 'swingle'};
            results = parser.parseMagically(struct());
            
            obj.assertEqual(results.foo, 2);
            obj.assertEqual(results.quux, 'swingle');
        end
        
        function testParseToObject(obj)
            parser = MipInputParser();
            parser.addRequired('foo', @isnumeric);
            parser.addParameter('quux', '4', @ischar);
            
            foo = 2;
            varargin = {'quux', 'swingle'};
            parser.parseMagically(obj);
            
            obj.assertEqual(obj.foo, 2);
            obj.assertEqual(obj.quux, 'swingle');
        end
        
        function testObjectProperties(obj)
            parser = MipInputParser();
            parser.addProperties(obj);
            
            varargin = {'foo', 2, 'quux', 'swingle'};
            parser.parseMagically(obj);
            
            obj.assertEqual(obj.foo, 2);
            obj.assertEqual(obj.quux, 'swingle');
        end
        
        function testPreference(obj)
            setpref('MipTests', 'foo', 2);
            setpref('MipTests', 'quux', 'pref-default');
            
            parser = MipInputParser();
            parser.addPreference('MipTests', 'foo', 22, @isnumeric);
            parser.addPreference('MipTests', 'quux', 'unused', @ischar);
            parser.addPreference('MipTests', 'geez', 'fallback', @ischar);
            
            varargin = {'foo', 222};
            results = parser.parseMagically(struct());
            
            % should use given value for foo
            obj.assertEqual(results.foo, 222);
            
            % should use preference value for quuz
            obj.assertEqual(results.quux, 'pref-default');
            
            % should use fallback default for geez
            obj.assertEqual(results.geez, 'fallback');
            
            rmpref('MipTests');
        end
        
        function testItemIsAny(obj)
            parser = MipInputParser();
            parser.addRequired('foo', parser.isAny(77, 'cheese', 2));
            parser.addParameter('quux', '4', parser.isAny('swingle', '4'));
            
            foo = 2;
            varargin = {'quux', 'swingle'};
            results = parser.parseMagically(struct());
            
            obj.assertEqual(results.foo, 2);
            obj.assertEqual(results.quux, 'swingle');
        end
        
        function testItemIsNotAny(obj)
            parser = MipInputParser();
            parser.addRequired('foo', parser.isAny(77, 'cheese'));
            parser.addParameter('quux', '4', parser.isAny('swingle', '4'));
            
            foo = 2;
            varargin = {'quux', 'swingle'};
            
            try
                results = parser.parseMagically(struct());
            catch err
                obj.assertEqual(err.identifier, 'MATLAB:InputParser:ArgumentFailedValidation');
                return;
            end
            
            error('Should have returned from catch, above');
        end
    end
end