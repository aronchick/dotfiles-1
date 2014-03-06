# change editor from the nano default
export EDITOR=vim
export VISUAL=vim

if [ -d "$HOME/opt/aws" ] ; then
  export EC2_HOME=~/opt/aws/ec2
  export AWS_AUTO_SCALING_HOME=~/opt/aws/as
  export AWS_CLOUDWATCH_HOME=~/opt/aws/cw
  export AWS_AMITOOLS_HOME=~/opt/aws/ami
fi

if [ -d "$HOME/opt/aws/priv" ] ; then
  export EC2_PRIVATE_KEY=`ls ~/opt/aws/priv/pk-*.pem`
  export EC2_CERT=`ls ~/opt/aws/priv/cert-*.pem`
  export AWS_CREDENTIAL_FILE=~/opt/aws/priv/credentialsfilepath.txt
fi