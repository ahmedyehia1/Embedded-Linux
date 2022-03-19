#! /bin/bash
 
function helper(){
	echo "Phonebook Script"
	echo "Available Options:"
 
	echo " 
 -i:	insert new phone number
  	usage: ./Phonebook.bash -i <name> <number>"
  	echo " 
 -v:	view all phone numbers
  	usage: ./Phonebook.bash -v"
  	echo " 
 -s:	insert search for a phone number by its name
  	usage: ./Phonebook.bash -s <name>"
  	echo " 
 -e:	delete all phone numbers
  	usage: ./Phonebook.bash -e"
	echo " 
 -d:	delete phone number by its name
  	usage: ./Phonebook.bash -d <name>"
 
}
function insertNumber(){
	foundNumber=$(grep -w $1 Phonebook.db)
	if [ -z $foundNumber ]
	then
		echo "$1:$2" >> Phonebook.db
		echo "OK: phone number is stored successfully"
	else
		echo "ERROR: name specified is already stored"
	fi
}
function viewAll(){
	allRecords=$(cat Phonebook.db)
	echo "Name		Number"
	echo
	for i in $allRecords 
	do
		echo "$(echo  $i | cut -d: -f1)	$(echo  $i | cut -d: -f2)"
	done
}
function searchByName(){
	foundNumber=$(grep -w $1 Phonebook.db)
	if [ -z $foundNumber ]
	then
		echo "ERROR: name specified is not stored"
	else
		echo $foundNumber > Phonebook_temp_file
		echo "Name		Number"
		echo
		echo "$(cut -d: -f1 Phonebook_temp_file)	$(cut -d: -f2 Phonebook_temp_file)"
		rm Phonebook_temp_file
	fi
}
function deleteAll(){
	read -p "are you sure you want to delete all phone numbers? (y: yes, n:no) " proceed
	if [ $proceed == "y" ]
	then
		echo "" > Phonebook.db
		echo "OK: all phone numbers are deleted successfully"
	elif [ $proceed == "n" ]
	then
		echo "OK: nothing is deleted"
	else
		echo "ERROR: wrong input"
	fi
}
function deleteByName(){
	foundNumber=$(grep -w $1 Phonebook.db)
	if [ -z $foundNumber ]
	then
		echo "ERROR: name specified is not stored"
	else
		read -p "are you sure you want to delete $1 phone number? (y: yes, n:no) " proceed
		if [ $proceed == "y" ]
		then
			echo $(grep -v $1 Phonebook.db) > Phonebook.db
			echo "OK: phone number is deleted successfully"
		elif [ $proceed == "n" ]
		then
			echo "OK: nothing is deleted"
		else
			echo "ERROR: wrong input"
		fi
	fi
}
 
option=$1
name=$2
number=$3

if [ ! -f "Phonebook.db" ]
    then
    touch Phonebook.db
fi
case "$option" in 
"-i")
	if [ -z "$name" ] && [ -z "$number" ]
	then
		echo "ERROR: neither name nor number specified"
	elif [ -z "$number" ] 
	then
		echo "ERROR: no number specified"
	else
		insertNumber $2 $3
	fi;;
 
 
"-v")
	viewAll;;
 
 
"-s")
	if [ -z "$name" ] 
	then
		echo "ERROR: no name specified"
	else
		searchByName $2
	fi;;
 
 
"-e")
	deleteAll;;
 
 
"-d")
	if [ -z "$name" ] 
	then
		echo "ERROR: no name specified"
	else
		deleteByName $2
	fi;;
 
 
*)
	helper;;
esac