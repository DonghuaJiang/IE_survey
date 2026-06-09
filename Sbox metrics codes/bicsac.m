function [sac,dep]=bicsac(box)
% Evaluates given 8x8 SBox
format long
% x10
% init
% m3
% arr=randperm(256);
% arr=arr-1;
        size1=256; size2=16; size3=8;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % fprintf('The final s-box created is ');
        box=reshape(box,1,256);
        %%%%%%%%%%%%%%%%%%%%%%%%%%making one d array from 2-d
        %trying strict avalanche criterion
        % we will be picking values from 1-d created s-box array 
        counter=0;
        av=[1 2 4 8 16 32 64 128];
        arr=zeros(size3,size1);
        mm=1;
        for hh=1:1:size2
            for jj=1:1:size2
                nn=1;%%%%used to segregate the different arrays based on jth bit changed
                for kk=1:1:size3
                    s1=bitxor(counter,av(kk));
                    arr(nn,mm)=bitxor(box(counter+1),box(s1+1)); % holds Vk=Y+Yk
                    %arr(mm)=s1;
                    nn=nn+1;
                    %mm=mm+1;
                end
                mm=mm+1;
                counter=counter+1;
            end
        end

%         %%%%%using this as counter for counting the number of 1's
%         counter=zeros(size3);
% 
%         %%%%%%%%%%new addition here%%%%%%%%%%%%
%         dep=zeros(8,8);
%         for hh=1:1:size3
%             for jj=1:1:size1
%                 var=arr(hh,jj);%%storing the value in temporary variable %%
%                 %var
%                 for kk=1:1:size3
%                     tmp11=bitget(var,kk);
%                     %tmp11
%                     %counter(kk)=counter(kk)+mod(var,2);
%                     counter(kk)=counter(kk)+tmp11;
%                     %counter(kk)
%                     %var=var/2;
%                     %var
%                 end
%             end
%             for rr=1:1:size3
%                 dep(hh,rr)=counter(rr)/(size1);%*2);
%                 counter(rr)=0;
%             end
%         end
% 
% 
%         % fprintf('The dependence matrix is : ');
%         dep;
% 
%         sac=0;      
%         for hh=1:1:size3
%             for jj=1:1:size3
%                 sac=sac+dep(hh,jj);
%             end
%         end
%         sac=sac/(size3*size3);%-(size3/2));
% 
%         sac;
% 
%         if sac>0    
%             if sac<1
%                 % fprintf('avalanch criterion is satisfied as 0 < sac < 1\n\n');
%             end
%         end

        dep=zeros(size3,size3);
        sac=0;
        for j=1:1:size3
            for k=1:1:size3
                for node=1:1:size1
                    for i=1:1:size3
                        v=arr(i,node);
                        b1=bitget(v,j);
                        b2=bitget(v,k);
                        dep(j,k)=dep(j,k)+mod(b1+b2,2); 
                    end
                end
                dep(j,k)=dep(j,k)/(size3*size1);
                sac=sac+dep(j,k);
            end
        end
        %%%%%%%%%%%AVALANCHE CRITERIA CALCULATED%%%%%%%%%
        sac=sac/(size3*size3-size3);
        sacdiff=abs(sac-0.5);
        sacdiff;
