function [sac,dep]=sac(arr)
        size1=256; size2=16; size3=8;
        box2=arr;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        arr=reshape(arr,1,256);
        box=arr;
        %%%%%%%%%%%%%%%%%%%%%%%%%%making one d array from 2-d
        %trying strict avalanche criterion
        % we will be picking values from 1-d created s-box array 
        counter=0;
        mm=1;
        for hh=1:1:size2
            for jj=1:1:size2
                nn=1; %%%%used to segregate the different arrays based on jth bit changed
                for kk=1:1:size3
                    s1=bitxor(counter,2^(kk-1));
                    arr(nn,mm)=bitxor(box(1,counter+1),box(1,s1+1));
                    nn=nn+1;
                end
                mm=mm+1;
                counter=counter+1;
            end
        end
        %%%%%using this as counter for counting the number of 1's
        counter(1:size3)=0;
        %%%%%%%%%%new addition here%%%%%%%%%%%%
        dep=zeros(8,8);
        tmp11=intmax('int8');
        for hh=1:1:size3
            for jj=1:1:size1
                var=arr(hh,jj);%%storing the value in temporary variable %%
                %var
                for kk=1:1:size3
                    tmp11=bitget(var,kk);
                    counter(kk)=counter(kk)+tmp11;
                end
            end
            for rr=1:1:size3
                dep(hh,rr)=counter(rr)/(size1);
                counter(rr)=0;
            end
        end

        % fprintf('The dependence matrix is : ');
        dep;        
        sac=0;      
        for hh=1:1:size3
            for jj=1:1:size3
                sac=sac+dep(hh,jj);
            end
        end
        sac=sac/(size3*size3);