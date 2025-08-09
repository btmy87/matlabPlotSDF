classdef test_readSDF < matlab.unittest.TestCase

    methods (TestClassSetup)
        % Shared setup for the entire test class
        function get_examples(~)
            % get two example files for testing

            % caffeine molecule
            system('curl https://webbook.nist.gov/cgi/cbook.cgi?Str3File=C58082 -o ex1.sdf');

            % complex molecule with > 100 atoms
            system('curl https://webbook.nist.gov/cgi/inchi?Str3File=R507027 -o ex2.sdf');
        end
    end

    methods (TestMethodSetup)
        % Setup for each test
    end

    methods (Test)
        % Test methods

        function atoms1Test(testCase)
            % verify we read atoms correctly from small file
            [x, y, z, atoms] = readSDF("ex1.sdf");
            testCase.verifyEqual(length(x), 24);
            testCase.verifyEqual(length(y), 24);
            testCase.verifyEqual(length(z), 24);
            testCase.verifyEqual(length(atoms), 24);

            testCase.verifyEqual(x(1), -0.8846);
            testCase.verifyEqual(y(10), 2.6644);
            testCase.verifyEqual(z(24), 0.7654);
            testCase.verifyEqual(atoms(1), "C");
            testCase.verifyEqual(atoms(24), "H");
        end

        function bonds1Test(testCase)
            % verify we read bonds correctly for small file
            [~, ~, ~, ~, idx1, idx2, bond] = readSDF("ex1.sdf");
            testCase.verifyEqual(length(idx1), 25);
            testCase.verifyEqual(length(idx2), 25);
            testCase.verifyEqual(length(bond), 25);

            testCase.verifyEqual(idx1(1), 2);
            testCase.verifyEqual(idx2(25), 24);
            testCase.verifyEqual(bond(1), 2);
            testCase.verifyEqual(bond(2), 1);

            testCase.verifyTrue(all(idx1 >= 1));
            testCase.verifyTrue(all(idx2 >= 1));
            testCase.verifyTrue(all(bond >= 1));
            testCase.verifyTrue(all(idx1 <= 24));
            testCase.verifyTrue(all(idx2 <= 24));
            testCase.verifyTrue(all(bond <= 3));

        end
        
        function atoms2Test(testCase)
            % verify we read atoms correctly from big file
            [x, y, z, atoms] = readSDF("ex2.sdf");
            testCase.verifyEqual(length(x), 118);
            testCase.verifyEqual(length(y), 118);
            testCase.verifyEqual(length(z), 118);
            testCase.verifyEqual(length(atoms), 118);

            testCase.verifyEqual(x(1), 5.0195);
            testCase.verifyEqual(y(10), -0.8920);
            testCase.verifyEqual(z(118), -0.4350);
            testCase.verifyEqual(atoms(1), "C");
            testCase.verifyEqual(atoms(118), "H");
        end

        function bonds2Test(testCase)
            % verify we read bonds correctly for big file
            [~, ~, ~, ~, idx1, idx2, bond] = readSDF("ex2.sdf");
            testCase.verifyEqual(length(idx1), 119);
            testCase.verifyEqual(length(idx2), 119);
            testCase.verifyEqual(length(bond), 119);

            testCase.verifyEqual(idx1(1), 1);
            testCase.verifyEqual(idx2(119), 50);
            testCase.verifyEqual(bond(1), 2);
            testCase.verifyEqual(bond(2), 1);

            testCase.verifyTrue(all(idx1 >= 1));
            testCase.verifyTrue(all(idx2 >= 1));
            testCase.verifyTrue(all(bond >= 1));
            testCase.verifyTrue(all(idx1 <= 118));
            testCase.verifyTrue(all(idx2 <= 118));
            testCase.verifyTrue(all(bond <= 3));

        end

    end

end