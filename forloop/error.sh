#!/bin/bash
 create_directory () {
         mkdir demo
 }
if ! create_directory ; then
        echo "the directoty already exits"
        exit 1 
fi
echo "this will not be executed becaise there is error in code"
