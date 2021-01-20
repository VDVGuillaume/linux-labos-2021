#! /bin/bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
#/ Usage: jarvis COMMAND
#/
#/ Commands I understand:
#/
#/ - help
#/ - make me a sandwich
#/ - teach me something/tell me something cool
#/ - what day is it
#/ - take a note <sentence>
#/ - show my notes

#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
#}}}

#{{{ Variables
readonly dependencies="cowsay
curl
figlet
fortune
jq
lolcat"
readonly notebook=
readonly sandwich="                                ██████
                              ██      ████
                          ████            ████
                      ████                    ████
                  ████        ░░                  ████
                ██                                    ████
      ██████████                  ░░                      ██
    ██    ▒▒▓▓            ░░                ░░              ██
  ██                                                      ▒▒██
  ██                                  ░░              ░░▒▒░░██
  ██▓▓                                            ░░▒▒▒▒░░░░██
  ██▒▒▓▓      ░░                                ▓▓▒▒░░▒▒░░▓▓▓▓██
  ██▒▒▓▓▓▓▓▓                ░░      ░░        ▓▓▒▒▒▒░░▓▓▓▓▓▓▒▒██
██▓▓░░▓▓▓▓▓▓▓▓        ░░                  ▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▒▒▓▓██
██░░▒▒▓▓██▓▓▓▓▓▓▓▓                    ▓▓▓▓▒▒▒▒▓▓▓▓░░░░▓▓▒▒░░██
  ██▒▒░░▓▓▒▒▓▓▓▓▓▓▓▓▓▓                ▓▓▓▓▒▒▓▓░░░░░░░░░░▓▓░░██
  ██▒▒▒▒░░▓▓▒▒██▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓░░░░░░░░  ▒▒░░██
  ██▒▒░░▒▒▒▒▒▒▓▓▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░▒▒▒▒▒▒░░████
    ██▓▓▓▓░░▒▒▒▒░░▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒████
      ██▓▓██░░░░░░▒▒▒▒▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░▒▒▒▒████
        ████▓▓██░░░░░░▒▒░░▒▒▒▒▓▓▒▒▓▓▒▒░░▓▓▒▒██
            ██▓▓▓▓██░░░░▓▓░░▒▒░░▒▒▒▒▓▓▒▒▓▓██
              ████▓▓▓▓░░░░▓▓░░▓▓░░░░▒▒▓▓██
                  ████▓▓▓▓██████▓▓▓▓▓▓▓▓██
                      ██████▓▓▓▓▓▓▓▓████
                            ████████
"
wikipedia_url="https://en.wikipedia.org/api/rest_v1/page/random/summary"
#}}}

# Main function with dependency/argument checking and command dispatcher
main() {
  # Fist, check dependencies
  check_dependencies

  # If no arguments were given, show a usage message and exit

  # With a case statement, check if the positional parameters, as a single
  # string, matches one of the text patterns Jarvis understands.
  case "$@" in
    "")
      print_usage
    ;;
    "make me a sandwich")
      make_sandwich
    ;;
    "tell me"* | "teach me"* )
      show_random_wikipedia_entry
    ;;
    "what day is it")
      show_day
    ;;
    "take a note"*)
      take_note "$@"
    ;;
    *)
      echo "Sorry, I don't understand"
      exit 1
    ;;
  esac
}

#{{{ Helper functions

# Usage: check_dependencies
#
# Iterates over the commands enumerated in variable ${dependencies} and calls
# is_installed to check whether the command exists. If not, try to install 
# the command using dnf.
# If the installation of the command didn't succeed, the script stops with exit status 2.
check_dependencies() {
  # Loop over all dependencies, and check if they are installed using the
  # is_installed function
gefaald="FALSE"
  for dep in $dependencies; do
    #result=$(is_installed "$dep")
    #echo "$result"
    is_installed "$dep"
    if [ "$installed" -ne 0 ];then
      $gefaald="TRUE"
      echo "Could not find command $dep. Please install it first"
    fi
  done
  if [[ "$gefaald" == "TRUE" ]];then
    exit 2
  fi
}

is_installed() {
  which "$1" > /dev/null
  installed="$?"
}

# Usage: usage
#
# Print usage message on stdout
print_usage() {
  echo "Hello ${USER}, I am Jarvis, your humble servant!"

  # Search in the current script for lines starting with the "special" comment
  # `#/`. Strip the comment and any following whitespace.
  cat jarvis.sh | grep '^#/' | sed 's/#\/ *//'
}

# Usage: make_sandwich
#
# If this script was called by the superuser, print the ASCII-drawing of
# a sandwich. If not, politely refuse.
make_sandwich() {
  if [ "$EUID" -ne 0 ]; then
    echo "What? Make it yourself."
  else
    echo "$sandwich" | lolcat
  fi
}

# Usage: show_random_wikipedia_entry
#
# Downloads a random summary page from Wikipedia and presents it to the user.
show_random_wikipedia_entry() {
  # Generate a random name for a temporary file with mktemp, store it in a
  # local variable
  local temp_file=$(mktemp)

  # Download ${wikipedia_url} and store the contents in the temporary file
  curl -L -sS "${wikipedia_url}" > "${temp_file}"
  # Fetch the "title" field from the JSON file and print it in green
  title=$(jq -r .title $temp_file)
  printf "\033[0;34m%s\n" "$title"

  # Fetch the "description" field from the JSON file and print it
  content=$(jq -r .extract $temp_file)
  printf "\033[0;37m%s\n" "$content"
}

# Usage: show_day
#
# Have cowsay (with a random animal) prints today's full weekday name 
show_day() {
  # Get the current day, store it in a local variable
  local day=$(date '+%A')
  # Select a cow file from /usr/share/cowsay at random
  local cow=$(ls /usr/share/cowsay | grep '\.cow' | shuf -n 1)
  echo "$cow"
 # Print the day using cowsay
  echo "Today, it's"...
  cowsay -f /usr/share/cowsay/$cow "$day"
}

# Usage: take_note NOTE
#
# With NOTE a sentence. It will be added to the end of the user's notebook
# You can presume the notebook file exists!
take_note() {
  # Add the note to the end of the notebook, preceded with '- '
  
  echo "-$@" | sed 's/take a note//' >> notebook
  # Write out the word "Noted" in a colored, fancy font
  printf "\033[0;34m%s\n" "Noted"
}

#}}}

main "${@}"

