#!/bin/bash
# Use only if you need to perform changes on the user system such as installing software
[[ -z $(which bc) ]] && sudo apt-get install bc
[[ -z $(which ssmpt) ]] && sudo apt-get install ssmpt
