pic=imread('yuan_32.png');
dimen=8;
originalpath='G:\paper-ruoyu\HF-TPE\code2\helen_1\';
pathname=strcat(originalpath,['en_','dimen_',num2str(dimen),'\']);
filename='11.png';
pathfile=[pathname filename];
imwrite(pic,pathfile,'png');