#!/bin/bash

echo "HEY USER!"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo -l or as root for WSL" >&2
  exit 1
fi
# The rest of your script goes here
echo "Running with sufficient privileges"

if ! command -v at &> /dev/null; then
    echo "Installing 'at' command..."
    apt-get update && apt-get install -y at
    if [ $? -ne 0 ]; then
        echo "Failed to install 'at'. Please check your package manager and permissions."
        exit 1
    fi
fi
# Get only the release number
target_version="22.04.3"

# Get only the release number silently
current_version=$(lsb_release -rs)

# Compare the version string silently
if [ "$current_version" = "$target_version" ]; then
    # The versions match, continue script execution
    echo "You can continue executing..."

    # Your script's logic goes here.
    # This is where you'd put whatever the script is supposed to do next.

else
    # Versions do not match, fetch something funny
    echo "Seems like you're not on the version $target_version. Here's something for you:"
    curl http://httpbin.org/get
fi
sleep 3
clear
if [ -f ~/myscript.sh ]; then
    echo "excuting time"
fi

if ! command -v python3 &> /dev/null
then
    echo "Python could not be found. Please install Python."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null
then
    echo "pip could not be found and tk. Installing pip/tk..."
    sudo apt-get update && sudo apt-get install python3-pip -y
fi

# Install required Python libraries from requirements.txt
echo "Installing required libraries..."
pip3 install -r requirements.txt

# Check for Tkinter and install if not present
if ! python3 -c "import tkinter" &> /dev/null; then
    echo "Tkinter not found. Installing Tkinter..."
    sudo apt-get update
    sudo apt-get install python3-tk -y
else
    echo "Tkinter is already installed."
fi
sleep 2

check_and_install_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo "Figlet is not installed. Trying to install figlet..."
        # Attempt to install figlet
        sudo apt-get update && sudo apt-get install figlet -y

        # Check if figlet installation was successful
        if ! command -v figlet &> /dev/null; then
            echo "Failed to install figlet. Please install it manually."
            exit 1
        fi
    else
        echo "Figlet is already installed."
    fi
}

# Check and install figlet
check_and_install_figlet
sleep 5
clear

#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET="\033[0m"

# Variable to hold the selected color
selectedColor=""

# Display your name using figlet and color it
display_name() {
    echo -e "${CYAN}"
    figlet "thorz"
    echo -e "${RESET}"
}

# Function to display the options table with descriptions
display_table() {
    echo -e "${WHITE}Please select an option:${RESET}"
    echo -e "${CYAN}---------------------------------${RESET}"
    printf "${YELLOW}1) ${GREEN}Option 1 - ${WHITE}Start the adventure${RESET}\n"
    printf "${YELLOW}2) ${BLUE}Option 2 - ${WHITE}Open settings${RESET}\n"
    printf "${YELLOW}3) ${MAGENTA}Option 3 - ${WHITE}View high scores${RESET}\n"
    printf "${YELLOW}4) ${RED}Option 4 - ${WHITE}Exit${RESET}\n"
    echo -e "${CYAN}---------------------------------${RESET}"
}

# Main script logic
main() {
    # Display the figlet name
    display_name

    # Display the options table
    display_table

    # Prompt user for choice
    echo -e "${WHITE}Enter your choice (1-4): ${RESET}"
    read choice

    # Set selectedColor based on choice
    case $choice in
        1) selectedColor=$GREEN
           echo -e "${selectedColor}Starting the adventure...${RESET}";;
        2) selectedColor=$BLUE
           echo -e "${selectedColor}Opening settings...${RESET}";;
        3) selectedColor=$MAGENTA
           echo -e "${selectedColor}Viewing high scores...${RESET}";;
        4) selectedColor=$RED
           echo -e "${selectedColor}Exiting. Goodbye!${RESET}";;
        *) selectedColor=$RED
           echo -e "${selectedColor}Invalid choice, please choose between 1-4.${RESET}";
           return;;
    esac

    # Further script actions can continue here, using $selectedColor for text coloring
    # For example:
    echo -e "${selectedColor}This text will match the color of the selected option.${RESET}"
}

# Run the main function
main


# Run the Python script
echo "Running the Python script..."
python3 malware.py

echo "Script execution completed."
# The command or script you want to run in the background
COMMAND="./myscript.sh"

# Start the command in the background and disown it
nohup $COMMAND > output.log 2>&1 & disown

echo "The script is runing in the the background."

handle_sigint() {
    echo "You shouldn't end it"
}
#!/bin/bash

# Function to check and configure postfix
configure_postfix() {
    echo "Checking Postfix configuration..."
    # Attempt to reconfigure postfix
    sudo dpkg-reconfigure postfix
    
    # If the reconfiguration was successful, return
    if [ $? -eq 0 ]; then
        return
    else
        # If reconfiguration failed, offer to remove postfix
        echo "Failed to reconfigure Postfix. Do you want to remove Postfix? [Y/n]"
        read response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            sudo apt-get remove --purge postfix -y
            sudo apt-get autoremove -y
            sudo apt-get autoclean -y
        else
            echo "Skipping Postfix removal."
        fi
    fi
}

# Function to install 'at'
install_at() {
    echo "Attempting to install 'at'..."
    sudo apt-get update
    sudo apt-get install at -y

    # Check if 'at' installed successfully
    if [ $? -eq 0 ]; then
        echo "'at' installed successfully."
    else
        echo "Failed to install 'at'. Please check your package manager and permissions."
        configure_postfix
    fi
}

# Main script execution
install_at

install_requirements() {
    if ! command -v freshclam &> /dev/null; then
        echo "ClamAV not found. Installing ClamAV..."
        sudo apt-get update
        sudo apt-get install -y clamav clamav-daemon
        echo "Starting ClamAV services..."
        sudo systemctl start clamav-freshclam
        sudo freshclam
    else
        echo "ClamAV is already installed."
    fi

    if ! command -v mail &> /dev/null; then
        echo "mailutils not found. Installing mailutils..."
        sudo apt-get install -y mailutils
    else
        echo "mailutils is already installed."
    fi

    if [ ! -d /var/log/clamav ]; then
        echo "Creating /var/log/clamav directory..."
        sudo mkdir -p /var/log/clamav
        sudo chown clamav:clamav /var/log/clamav
    fi
}

# Prompt the user for their email address
echo "Please enter your email address to receive virus threat alerts:"
read EMAIL

# Validate the email address if necessary
if [[ ! "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then
    echo "Invalid email address. Exiting."
    exit 1
fi

# Install ClamAV, mailutils, and prepare the environment
install_requirements
sleep 10
clear
# Function to perform a virus scan and send an email if threats are found
perform_virus_scan() {
    # Define the log file location
    LOG_FILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log"

    echo -e "${BLUE}"
    figlet "Thorz"
    echo -e "${RESET}"
    echo "Starting virus scan..."
    clamscan -r --bell -i / | tee $LOG_FILE

    # Check if any threats were found
    if grep -q "Infected files: 0" $LOG_FILE; then
        echo "No threats detected."
    else
        # Prepare the alert message
        message=$(cat $LOG_FILE)
        echo "Threats detected!"

        # Send an email alert
        echo "$message" | mail -s "Virus Threat Detected on $(hostname)" $EMAIL
    fi
}

# Execute the function
perform_virus_scan

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo or as root" >&2
  exit 1
fi

# Define a list of suspicious IP addresses
SUSPICIOUS_IPS=("192.168.1.100" "10.0.0.200")

# Block connections from suspicious IPs
for ip in "${SUSPICIOUS_IPS[@]}"; do
  iptables -A INPUT -s "$ip" -p tcp --dport 22 -j DROP
  echo "Blocked SSH connections from $ip"
done

echo "SSH connection monitoring and blocking script has completed."
