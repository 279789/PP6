#!/usr/bin/env bash

function greeting {
echo "Hello Worlf"
}

print_greeting () {
	echo Hello from Bash!
}

print_vars () {
	local name="Bash"
       	local version=5.1
	printf " We are using %s in version %.1f \n" "$name" "$version"

}

print_escape () {
	printf "Newline\nTab:\tHehe\n"
	printf "\e[32m I m Shreek \e[0m I m Normal\n"
}
