#!/usr/bin/env bash

check_command(){
    if [ $? -ne 0 ]; then
        echo "$1"
        echo "Installation is not completed"  
        echo "Press any key to close..."  
        read
        exit
    fi
}


run_command() {
    echo -e "$2\n"
    eval $1 &>/dev/null && sleep 2
    check_command "$2 failed"
}
