function [x,y] = create_training_set_class(n,delta)
% [x,y] = create_training_set(l)  x[l,d] y[l,1]

i=1;
J=0;
j=0;
while i<=n/2
    x_temp1 = rand(1);
    x_temp2 = rand(1);
    p = rand(1);
    
    if (x_temp2 <=  fx_class(x_temp1) & p<delta)
        x(i,1)=x_temp1;
        x(i,2)=x_temp2;
        y(i)=1;
        i=i+1;
        
    elseif  (x_temp2 >  fx_class(x_temp1) & p>delta)
        x(i,1)=x_temp1;
        x(i,2)=x_temp2;
        y(i)=1;
        i=i+1;
      
    end
end
while i<=n
        x_temp1 = rand(1);
        x_temp2 = rand(1); 
        p = rand(1);
    if (x_temp2 >=  fx_class(x_temp1) & p<delta)
        x(i,1)=x_temp1;
        x(i,2)=x_temp2;
        y(i)=-1;
        i=i+1;
        J=J+1;
    elseif  (x_temp2 <  fx_class(x_temp1) & p >   delta)
     x(i,1)=x_temp1;
        x(i,2)=x_temp2;
        y(i)=-1;
        i=i+1;
          j=j+1;
    end
end
y=y';
