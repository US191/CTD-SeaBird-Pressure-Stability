function result = runtests
import matlab.unittest.TestSuite

suiteFolder = testsuite('testDemo');

if nargout == 1
  result = run(suiteFolder);
else
  run(suiteFolder);
end