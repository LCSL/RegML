function [test_err,Ytest_learned] = linear_test(Xtest,Ytest,beta,type,meanY)
% LINEAR_TEST prediction error for linear model
%   [TEST_ERR] = LINEAR_TEST(XTEST,YTEST,BETA) returns the classification 
%   error committed by BETA on the test set XTEST, YTEST.
% 
%   [TEST_ERR,YTEST_LEARNED] = LINEAR_TEST(XTEST,YTEST,BETA) also returns the
%   estimated value for the test samples.
%
%   [...] = LINEAR_TEST(XTEST,YTEST,BETA,TYPE) if TYPE='REGR'(default) 
%   evaluates the regression error; if TYPE = [FRAC_POS FRAC_NEG] evaluates the 
%   classification error, and weights errors on positive and negative samples 
%   with FRAC_POS and FRAC_NEG, respectively; if TYPE = 'class' evaluates the 
%   classification error, and weights both errors on positive and negative samples 
%   with 1/2 (balanced data).
%
%   [...] = LINEAR_TEST(XTEST,YTEST,BETA,TYPE,MEANY) adds offset MEANY to 
%   regression function: Y = X*BETA + MEANY.
%
if nargin<3; error('too few inputs!'); end
if nargin<4; type = 'regr'; end
if nargin<5; meanY = 0; end
if nargin>5; error('too many inputs!'); end


Ytest_learned = Xtest*beta+meanY;
if strcmp(type,'class'); type = [1/2 1/2]; end
if isnumeric(type)
    class_fraction = type;
    Ytest_learned = sign(Ytest_learned);
    npos = sum(Ytest>0);
    nneg = sum(Ytest<0);
    test_err = 0;
    if npos>0;
        err_pos = sum((Ytest_learned(Ytest>0)~=sign(Ytest(Ytest>0))))/length(Ytest(Ytest>0));
        test_err = test_err + err_pos*max(class_fraction(1),nneg==0);
    end
    if nneg>0;
        err_neg = sum((Ytest_learned(Ytest<0)~=sign(Ytest(Ytest<0))))/length(Ytest(Ytest<0));
        test_err = test_err + err_neg*max(class_fraction(2),npos==0);
    end
elseif isequal(type,'regr')
    test_err = norm(Ytest_learned-(Ytest+meanY))^2/length(Ytest);
elseif isequal(type,'regr_discrete')
    Ytest_learned = round(Ytest_learned);
    test_err = norm(Ytest_learned-(Ytest+meanY))^2/length(Ytest);
end