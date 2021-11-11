echo $1
pushd .
cd /home/sky/SOUNDFILES

drive pull -no-prompt -ignore-name-clashes 00JelSound-1/CSLIB/$1

popd

