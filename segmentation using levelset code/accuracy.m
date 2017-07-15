msk=imread('C:\Users\wajdan\Desktop\DIP proj\Model_Xrays backup\Masks\JPCLN109.png');
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