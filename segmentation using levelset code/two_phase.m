

close all;
clear all; 
Img =imread('C:\Users\wajdan\Desktop\DIP proj\Model_Xrays backup\JPCLN004.png'); 
msk=imread('C:\Users\wajdan\Desktop\DIP proj\Model_Xrays backup\Masks\JPCLN004.png');

Img =double(Img(:,:,1));
A=255;
sigma = 4;
G=fspecial('gaussian',15,sigma);
Img=conv2(Img,G,'same'); 
nu=0.001*A^2; % coefficient of arc length term
sigma = 4; % scale parameter that specifies the size of the neighborhood
iter_outer=50; 
iter_inner=10;   % inner iteration for level set evolution
timestep=.1;
mu=1;  % cient for distance regularization term (regularize the level set function)
c0=1;
figure(1);
imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
% initialize level set function
initialLSF = c0*ones(size(Img));
%initialLSF(30:90,50:90) = -c0;
%initialLSF(30:200,50:220) = -c0;
initialLSF(25:220,25:220) = -c0;
u=initialLSF;
hold on;
contour(u,[0 0],'r');
title('Initial contour');
figure(2);
imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
hold on;
contour(u,[0 0],'r');
title('Initial contour');
epsilon=1;
b=ones(size(Img));  %%% initialize bias field
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
KI=conv2(Img,K,'same');
KONE=conv2(ones(size(Img)),K,'same');
[row,col]=size(Img);
N=row*col;
for n=1:iter_outer
    [u, b, C]= lse_bfe(u,Img, b, K,KONE, nu,timestep,mu,epsilon, iter_inner);

    if mod(n,2)==0
        pause(0.001);
        imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal;
        hold on;
        contour(u,[0 0],'r');
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;
    end
end
Mask =(Img>10);
Img_corrected=normalize01(Mask.*Img./(b+(b==0)))*255;
I=u
maxI = max(I(:));
minI = min(I(:));
bw = im2bw(I,(maxI - mean(I(:)))/(maxI - minI));
%%%%%%%%%%%%%%%Removing boundaries
%%%%%%%%%%%%%
fil=bw;
for x=1:25   
for y=1:256
     fil(x,y)=0;
end
end
%%%%%%%%%%%%%
for x=225:256   
for y=1:256
     fil(x,y)=0;
end
end 
% %%%%%%%%%%%%%
for x=1:256   
for y=1:40
     fil(x,y)=0;
end
end
%%%%%%%%%%%%%
for x=1:256   
for y=230:256
     fil(x,y)=0;
end
end
figure(3);
imagesc(fil); colormap(gray); title('Final Binary Mask'); axis off; axis equal;

msk=imread('C:\Users\wajdan\Desktop\DIP proj\Model_Xrays backup\Masks\JPCLN004.png');
same=0;
dif=0;
for x=1:256
    for y=1:256
        if msk(x,y)==bw(x,y) 
        	same=same+1;
        else
            dif=dif+1;
        end
    end
end
same/(same+dif)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
