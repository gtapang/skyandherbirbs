echo 00JelSound-1/$3/$1-$2-$4
cd /home/sky/SOUNDFILES
#cd /mnt/user/Trantor/sky/SOUNDFILES

mkdir -p 00JelSound-1/$3/$1-$2-$4
chown sky:sky 00JelSound-1/$3/$1-$2-$4
drive pull -no-prompt -ignore-name-clashes 00JelSound-1/$3/$1-$2-$4
touch 00JelSound-1/$3/$1-$2-$4/__$1-$2-$4
chown sky:sky -Rv 00JelSound-1/$3/$1-$2-$4


