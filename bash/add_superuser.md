# Local Superuser Setup Script
https://github.com/igoros777/x/blob/main/bash/add_superuser.sh

## Overview

This script automates the process of creating a local superuser, updating the `sudoers` file, deploying an SSH public key, and modifying the SSH server configuration to allow connections for the specified user group. It is designed for environments where administrative users require streamlined access setup.

---

## Features

- **User Creation**: Creates a new user with the specified attributes (e.g., username, group, home directory, shell).
- **Sudoers Update**: Adds the new user to the `sudoers` file with `NOPASSWD` privileges. A backup of the original `sudoers` file is created.
- **SSH Key Deployment**: Adds an SSH public key to the user's `~/.ssh/authorized_keys` file.
- **SSH Configuration Update**: Updates the `AllowGroups` directive in the SSH server configuration file (`sshd_config`) to allow connections for the user's group.
- **Error Handling**: Includes robust error handling and backups for critical configuration files.

---

## Prerequisites

- **Root Privileges**: The script must be run as `root` or with `sudo`.
- **Required Tools**: Ensure the following tools are installed:
  - `awk`
  - `visudo`
  - `systemctl`

---

## Configuration Variables

The following variables can be customized in the `configure()` function:

| Variable           | Description                                      | Default Value                 |
|--------------------|--------------------------------------------------|-------------------------------|
| `user_name`        | Name of the user to be created                   | `localadmin`                 |
| `user_group`       | Primary group for the user                       | `admins`                     |
| `user_home`        | Home directory for the user                      | `/home/localadmin`           |
| `user_shell`       | Default shell for the user                       | `/bin/bash`                  |
| `user_description` | Description for the user                         | `Local Administrator Account`|
| `sudoers_string`   | Sudoers entry for the user                       | `localadmin ALL=(ALL) NOPASSWD: ALL` |
| `ssh_public_key`   | Public key to be added to the user's SSH config  | **Replace with your SSH key**|
| `allow_groups`     | Group to be added to the `AllowGroups` directive | `sec-local-admin`            |
| `sshd_config`      | Path to the SSH server configuration file        | `/etc/ssh/sshd_config`       |

---

## Script Functions

### `configure()`
Initializes all configuration variables used throughout the script. Edit this function to customize the user details and other settings.

### `create_user()`
Creates the specified user if it does not already exist. Ensures the user is assigned the specified group, shell, and description.

### `create_home()`
Creates the home directory for the user, including the `.ssh` directory. Sets proper permissions and ownership.

### `update_sudoers()`
- Adds the user to the `sudoers` file with `NOPASSWD` privileges.
- Creates a timestamped backup of the original `sudoers` file before modifying it.
- Validates the `sudoers` entry using `visudo` to ensure syntax correctness.

### `update_authorized_keys()`
Adds the specified SSH public key to the user's `~/.ssh/authorized_keys` file. Ensures proper file permissions.

### `update_sshd_config()`
- Modifies the `sshd_config` file to include the user's group in the `AllowGroups` directive.
- Creates a timestamped backup of the original `sshd_config` file before applying changes.
- Restarts the SSH service (`sshd`) to apply the updated configuration.

---

## How to Use

1. Clone or copy this script to a location on your server.
2. Open the script in a text editor and modify the variables in the `configure()` function as needed.
3. Run the script as `root` or with `sudo`:
   ```bash
   sudo ./superuser_setup.sh
