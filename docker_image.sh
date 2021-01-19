#!/bin/bash

### Script to create docker images
## For questions, contact u5bt



echo " What base image do you want to use choose one
      1- centos
      2- ubuntu
      3- debian
      4- python
      5- alpine
      6- jenkins"
 
read ANSWER

echo "What tag are u using?" 
read TAG
echo "What port do you want to exposed? list them separate by space" 
read PORT
echo "List all softwares that need to be installed separate them with a space"
read SOF
echo "What is your username? "
read NAME
echo "What command should be run in the container? "
read COM
echo "what is the path to the file that needs to be copied in the container?"
read FILE
echo "What is the path where to copy the file?"
read P

 if [ $ANSWER -eq 1 ]

then 
OS=centos
elif [ $ANSWER -eq 2 ]
then
OS=ubuntu
elif [ $ANSWER -eq 3 ]
then
OS=debian
elif [ $ANSWER -eq 4 ]
then
OS=python
elif [ $ANSWER -eq 5 ]
then
OS=alpine
elif  [ $ANSWER -eq 6 ]
then
OS=jenkins
else 
echo "please make a choice between 1,2,3,4,5,6"
exit 1
fi
## Dockerfile creation
>Dockerfile

if [ -z ${TAG} ]
then
echo "FROM ${OS}" >> Dockerfile
else
echo "FROM ${OS}:${TAG}" >> Dockerfile
fi

echo "MAINTAINER $NAME" >> Dockerfile

case $OS in
   centos) echo -e "RUN yum update -y\nRUN yum  install ${SOF} -y" >> Dockerfile 
   ;;
   ubuntu|debian|python|jenkins) echo -e "RUN apt update\nRUN apt  install ${SOF} -y" >> Dockerfile 
   ;;
   alpine) echo "RUN apk  install ${SOF} -y" >> Dockerfile 
   ;;
   *) echo ""
    ;;
esac

[ -f ${FILE} ] && echo "COPY ${FILE} ${P} " >> Dockerfile
#[ -f ${FILE} ] || echo "This is the private image" >> ${FILE} ; echo "COPY ${FILE} ${P} " >> Dockerfile
echo "EXPOSE ${PORT} " >> Dockerfile
echo "CMD ${COM} " >> Dockerfile
echo -e "\n\n"
echo "**************************"
cat Dockerfile
echo "**************************"
echo -e "\n\n"
echo " the dockerfile is ready please enter your image name: "
read IM
echo "Now building your image please wait as this can take couple minutes"

docker rmi $(docker images | grep ${IM}:${NAME} |awk '{print$3}') -f 
docker build -t ${IM}:${NAME} . 

docker images |grep ${IM}.*${NAME}
if [ $? -eq 0 ]
then
echo "Your image was successfully created please run the command docker images to verify"
>Dockerfile
else
echo "Sorry something went wrong please try again..."
exit 2
fi


