#!/bin/bash

#source /etc/apache2/envvars
#exec apache2 -D FOREGROUND

exec supervisord -n  
