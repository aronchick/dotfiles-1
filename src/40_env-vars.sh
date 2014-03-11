# change editor from the nano default
export EDITOR=vim
export VISUAL=vim

# AWS specific variables
if [ -d "$HOME/opt/aws" ] ; then
  export EC2_HOME=~/opt/aws/ec2
  export AWS_AUTO_SCALING_HOME=~/opt/aws/as
  export AWS_CLOUDWATCH_HOME=~/opt/aws/cw
  export AWS_AMITOOLS_HOME=~/opt/aws/ami
fi

if [ $( ls ~/.ssh/id_aws-*.pem ) ] ; then
  export EC2_PRIVATE_KEY=`ls ~/.ssh/id_aws-*.pem`
fi
#if [ -d "~/opt/aws/priv" ] ; then
#  export AWS_CREDENTIAL_FILE=~/opt/aws/priv/credentialsfilepath.txt
#fi
#if [ $( `ls ~/opt/aws/priv/cert-*.pem` ) ] ; then
#  export EC2_CERT=`ls ~/opt/aws/priv/cert-*.pem`
#fi