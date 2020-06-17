function [test_err,Ytest_learned] = l1l2_test(Xtest,Ytest,beta)
% L1L2_test Test error
%   [TEST_ERR] = L1L2_TEST(XTEST,YTEST,BETA) returns the regression 
%   error committed by BETA on the test set XTEST, YTEST.
% 
%   [TEST_ERR,YTEST_LEARNED] = L1L2_TEST(XTEST,YTEST,BETA) also returns the
%   estimated value for the test samples.
%
Ytest_learned = Xtest*beta;
test_err = norm(Ytest_learned-Ytest)^2/length(Ytest);