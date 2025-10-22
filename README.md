# Vanta IT Debugging Script (Passenger)

## Overview
--------

This is a simple script for Passenger employees to quickly gather Vanta diagnostic information for the IT department.

It's designed to be run on a macOS machine that has the Vanta agent installed. It simplifies the debugging process by running the necessary commands and placing the output files directly on your Desktop, ready to be sent to IT.

## What the Script Does
--------------------

1.  **Runs Vanta Checks:** It runs `vanta-cli check-registration` and `vanta-cli doctor`.

2.  **Saves Output:** It saves the output of these commands into two separate `.txt` files (e.g., `251022-090000-username-registration.txt`).

3.  **Selects User:** It asks you which user account to save the files to. **You should select your own account.**

4.  **Moves Files:** It moves these files to the Desktop of the user you selected.

5.  **Self-Destructs:** After a 5-second countdown, the script deletes itself to keep your computer clean.

## Instructions for Use
--------------------

You can download and run this script with a single command.

1.  Open **Terminal** (you can find it in Spotlight with `Cmd + Space` and typing "Terminal").

2.  **If you are on a standard (non-admin) account:** Type `login` and press **Enter**. At the prompts, enter your **admin username** and **admin password**.

3.  Copy and paste the entire command below into your Terminal and press **Enter**.

4.  You will be prompted for your password. This is required to run the Vanta commands.

5.  Follow the on-screen prompts (i.e., select your username from the list).

### One-Liner Command

```
curl -L -O "https://raw.githubusercontent.com/changeableface/vanta_checks_macos/refs/heads/main/vanta-checks.sh" && chmod +x vanta-checks.sh && sudo ./vanta-checks.sh
```

What to do Next
---------------

After the script runs, you will see two new text files on your Desktop. Please send **both** of these files to IT. This will give the IT team the information they need to help you.