#!/bin/bash



RELEASE_NUMBER="01_09-08-2018"
INSTALLATION_PATH="$PWD/$RELEASE_NUMBER"

printf "\n%s\n" "****** Setting env variables... ******"



ENV_VAR_NEEDED=(MANPATH INFOPATH SHARE_PATH HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE HTSLIB_DIR KENT_SRC MACHTYPE PERL5LIB PATH)



#Make a copy of all the current required env variables so that they can be restored later if required
for var in "${ENV_VAR_NEEDED[@]}"; do
     eval "${var}_tmp=\$$var" 
done



#Unset the current required env variables
for var in "${ENV_VAR_NEEDED[@]}"; do
     unset $var;
done


#Set PATH to minimal default
export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"





env_variables=$(cat << EOF
export INSTALLATION_PATH="$INSTALLATION_PATH"
export PATH="$INSTALLATION_PATH/paths:$INSTALLATION_PATH/linuxbrew/bin:$INSTALLATION_PATH/linuxbrew/sbin:$PATH"
export MANPATH="$INSTALLATION_PATH/linuxbrew/share/man:$MANPATH"
export INFOPATH="$INSTALLATION_PATH/linuxbrew/share/info:$INFOPATH"

export SHARE_PATH="$INSTALLATION_PATH/paths"

#Required for repeatmasker
export HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE="$INSTALLATION_PATH/ENSEMBL_MOONSHINE_ARCHIVE"

#Add bioperl to PERL5LIB
export PERL5LIB="$PERL5LIB:$INSTALLATION_PATH/linuxbrew/opt/bioperl-169/libexec"

# Setup Perl library dependencies
export HTSLIB_DIR="$INSTALLATION_PATH/linuxbrew/opt/htslib"
export KENT_SRC="$INSTALLATION_PATH/linuxbrew/opt/kent"
export MACHTYPE=x86_64 

EOF
)

printf "%s\n\n" "$env_variables"

read -p "OK to set above env variables?: "  -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
   echo "$env_variables" > $HOME/.bashrc_linuxbrew
   source $HOME/.bashrc_linuxbrew
   printf "\n%s\n" "****** Done setting env variables... ******"
else

#Restore all the previous env variables which were unset
   for var in "${ENV_VAR_NEEDED[@]}"; do
     eval "export ${var}=\$${var}_tmp"
   done

   printf "\n%s\n" "****** new env variables not set ******"

   return 
fi

