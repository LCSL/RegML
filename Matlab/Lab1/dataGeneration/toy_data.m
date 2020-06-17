function [x,y,x_test,y_test]=toy_data(n,nt,p,test)
%function [x,y,x_test,y_test]=toy_data(n,p,test)
% n training set size, 
% p error probability
% test=[0/1] create or not the test set

[x,y] = create_training_set_class(n,p);
if test==1
    [x_test,y_test] = create_training_set_class(nt,p) ;
else
    x_test=0;
    y_test=0;
end
fprintf('built toy data: %d training and %d test\n',n,nt*test)
end