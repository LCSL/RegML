function [] = plot_training_set_class(handle, X,Y)
% plot_training_set(x,y)  x[N,d] y[N,1]
% cla(handle,'reset')
% n=length(x);
% x_temp=[0.02:.02:1];

%plot(handle, x_temp,fx_class(x_temp));

% plot(handle, x(1:n/2,1),x(1:n/2,2),'r+');
% hold on
% plot(handle, x((n/2+1):n,1),x((n/2+1):n,2),'gs');

hold on
plot(handle, X(Y > 0, 1), X(Y > 0, 2), 'r*')
hold on
plot(handle, X(Y < 0, 1), X(Y < 0, 2), 'b*')
% hold off

% axis auto
%title('Training set');

