#!/bin/bash

# Source script
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTNAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_BASENAME="$(basename ${SCRIPTNAME} .sh)"

# Section message
sectionMsg ()
{
	echo -e -n "\e[1m${1}\e[0m"
}
# Error message
errorMsg ()
{
	echo -e "\e[31m${1}\e[0m"
}
# Succeed message
okMsg ()
{
	echo -e "\e[32m${1}\e[0m"
}

# Dependencies checker
# @param {array[]}
# @example: checkDeps (ls)
checkDeps () {
	local DEPS=${1}

	for DEP in "${DEPS[@]}"; do
		sectionMsg "Checking dependency: ${DEP}..."
		local DEP_PATH=$(which ${DEP})
		[[ -e ${DEP_PATH} ]] || {
			errorMsg "NOT FOUND"
			exit 1
		}
		okMsg "FOUND"
	done
}

# Help
showHelp () {
	echo "Usage: ${SCRIPTNAME} [OPTIONS]"
	echo ""
	echo "A title"
	echo "A description"
	echo ""
	echo "Options:"
	echo "	-s,--switch=FILE	 A switch"
	echo '	-v,--value=[DIR]	 A value'

	echo ""

	exit 1
}


# Checks arguments and dump values
checkArgs () {
	sectionMsg "${SCRIPTNAME} options:"
	echo ""

	# A VAR: a path with tilde
	[[ -e ${VALUE} ]] || { # Tilde subsitution
		errorMsg "--value option is not valid. File not found: \"${VALUE}\""
		exit 1
	}
	sectionMsg "	VALUE: ${VALUE}"
	echo ""

	echo ""
}

# Arguments parser
for i in "$@"
do
	case $i in
		-h|--help)
		showHelp
		;;
		-v=*|--value=*)
		VALUE="${i#*=}"
		VALUE=${VALUE/#\~/$HOME}
		shift
		;;
		-s|--switch)
		SWITCH="SOME VALUE"
		shift
		;;

		*)
			# unknown option
		;;
	esac
done
if [[ -n $1 ]]; then
		echo "Last line of file specified as non-opt/last argument:"
		tail -1 $1
fi
