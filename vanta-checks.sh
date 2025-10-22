#!/bin/bash

VANTA_CLI_PATH="/usr/local/vanta/vanta-cli"

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run with sudo."
  exit 1
fi

ORIGINAL_USER=${SUDO_USER}
if [ -z "$ORIGINAL_USER" ]; then
    echo "Error: Could not determine the original user who ran sudo."
    exit 1
fi

ORIGINAL_USER_HOME=$(eval echo ~$ORIGINAL_USER)
SOURCE_DIR="${ORIGINAL_USER_HOME}/Public"

if [ ! -x "$VANTA_CLI_PATH" ]; then
    echo "Error: Vanta CLI not found at ${VANTA_CLI_PATH}"
    exit 1
fi

echo "Step 1: Running Vanta CLI checks..."

TIMESTAMP=$(date +%y%m%d-%H_%M_%S)
REGISTRATION_FILE="${TIMESTAMP}-${ORIGINAL_USER}-registration.txt"
DOCTOR_FILE="${TIMESTAMP}-${ORIGINAL_USER}-doctor.txt"

if ! "$VANTA_CLI_PATH" check-registration > "${SOURCE_DIR}/${REGISTRATION_FILE}" || \
   ! "$VANTA_CLI_PATH" doctor > "${SOURCE_DIR}/${DOCTOR_FILE}"; then
    echo "Error: A Vanta CLI command failed to execute properly."
    echo "Please check for any error messages above."
    rm -f "${SOURCE_DIR}/${REGISTRATION_FILE}" "${SOURCE_DIR}/${DOCTOR_FILE}"
    exit 1
fi

echo "Vanta checks completed successfully."
echo "Generated files in: ${SOURCE_DIR}"
echo ""


echo "Step 2: Select a user account to transfer the files to."

USERS=($(ls /Users | grep -vE '^(Shared|\.)'))

PS3="Enter the number for the target user: "

select TARGET_USER in "${USERS[@]}"; do
  if [[ -n "$TARGET_USER" ]]; then
    if [ "$TARGET_USER" == "$ORIGINAL_USER" ]; then
        echo ""
        echo "Files are already in ${ORIGINAL_USER}'s Public folder. No transfer needed."
        echo "Note: Filenames contain the original username ('${ORIGINAL_USER}') as no transfer occurred."
        echo ""
        echo "Opening ${SOURCE_DIR} in Finder..."
        su -l "$ORIGINAL_USER" -c "open '$SOURCE_DIR'"
        
        echo ""
        echo "This script will now self-destruct in 5 seconds..."
        
        # --- Countdown Loop 1 ---
        for i in {5..1}; do
            echo -ne "$i...\r"
            sleep 1
        done
        echo "" # Clear the countdown line
        
        echo "Deleting script."
        rm -- "$0"
        exit 0
    fi
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

echo ""
echo "User '${TARGET_USER}' selected."
echo ""


echo "Step 3: Transferring and renaming files..."

TARGET_DIR="/Users/${TARGET_USER}/Desktop"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: The Desktop directory for user '${TARGET_USER}' does not exist at ${TARGET_DIR}"
    exit 1
fi

NEW_REGISTRATION_FILE="${TIMESTAMP}-${TARGET_USER}-registration.txt"
NEW_DOCTOR_FILE="${TIMESTAMP}-${TARGET_USER}-doctor.txt"

mv "${SOURCE_DIR}/${REGISTRATION_FILE}" "${TARGET_DIR}/${NEW_REGISTRATION_FILE}"
mv "${SOURCE_DIR}/${DOCTOR_FILE}" "${TARGET_DIR}/${NEW_DOCTOR_FILE}"

chown "${TARGET_USER}:staff" "${TARGET_DIR}/${NEW_REGISTRATION_FILE}"
chown "${TARGET_USER}:staff" "${TARGET_DIR}/${NEW_DOCTOR_FILE}"

echo ""
echo "✅ Success!"
echo ""
echo "Files have been transferred to '${TARGET_DIR}' and ownership has been set to '${TARGET_USER}'."
echo ""
echo "Files successfully created and moved to ${TARGET_DIR} - yay! 🥳"
echo ""
echo "This script will now self-destruct in 5 seconds..."

# --- Countdown Loop 2 ---
for i in {5..1}; do
    echo -ne "$i...\r"
    sleep 1
done
echo "" # Clear the countdown line

echo "Deleting script."
rm -- "$0"

exit 0