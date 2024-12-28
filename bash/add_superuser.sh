#!/bin/bash
#
#                                      |
#                                  ___/"\___
#                          __________/ o \__________
#                            (I) (G) \___/ (O) (R)
#                                   Igor Os
#                               igor@igoros.com
#                                 2024-12-11
# ----------------------------------------------------------------------------
# Script description
# Add a local superuser Also, update sudoers, deploy SSH key, and update SSH
# server configuration to allow connections for the user's group.
#
# CHANGE CONTROL
# ----------------------------------------------------------------------------
# 2024-12-11  igor  wrote this script
# ----------------------------------------------------------------------------

configure() {
  user_name=localadmin
  user_group=admins
  user_home=/home/${user_name}
  user_shell=/bin/bash
  user_description="Local Administrator Account"
  sudoers_string="${user_name} ALL=(ALL) NOPASSWD: ALL"
  ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EBBBADAQABAAACAQDCGGDPbXtcWDA7hxbVz+mLStTJ2ph4hTazKjT/GCKGHiMkeDCWKJ3kOwHIChZru2eKD1JUJRdYNUx7P5qNTzNpaIyZqbW/UrHgZcBSED1ldSCoUYhJMechUmFQoIFEx9BCBb8xcLS5U4aIQ4KN8JGODknCQ0MT0104EPXAdxx4XJBD5acJivISBUwpLAgTxRnOJYVFkS/M8aVvepCx9WvSbsZfDlf4rtGVDWKMS1gepJJf+Pf85+ws0LF71+ka5/jrJaZ61ESd5/aawT1r4bbQZz0f+vhCxrT7lXj0Q8IuNMW8KEkkPXnKXJJluXIsKga9BWNv2GgULNkwj8MnDWGQ9B5rV+5gz0oxtLXcu+vDheKHoOr/q8VziJlBtVnRjxIB3znH3jAHnrP4g0SZUNA/iakTfMHutf1QeBl+16REUhDxKa5z1/K9dRLedeb2aItntuPHLIpg+g6GNs7IYaCgLDVqKhuiGOcHLfCwdyu/aljLao2LxadPJbumJDLdZWrynvJPKe6ka64BpIYcc46b4qCb2j+CWd2Or3T2nem99G3Ftlu3C9Zsb4UmCBoivVvnnWgkKa9gs584qF0sOV7ZUJPbafWknkUU7T0vTbntu/AqZcio4wp38McM+E1QGp2cFmeDCtKSpEVbvVLrSr/gqqrKuA4tKfKJlcFG417daw== localadmin@workstation.local"
  sshd_config_dir="/etc/ssh"
  sshd_config_file="sshd_config"
  sshd_config="${sshd_config_dir}/${sshd_config_file}"
  allow_groups="sec-local-admin"
}

create_user() {
  if ! id -u ${user_name} >/dev/null 2>&1; then
    useradd -m -d ${user_home} -g ${user_group} -s ${user_shell} -c "${user_description}" ${user_name}
  fi
}

create_home() {
  if [ ! -d "${user_home}/.ssh" ]; then
    mkdir -p "${user_home}/.ssh"
    chown -R "${user_name}:${user_group}" "${user_home}"
    chmod 700 "${user_home}/.ssh"
  fi
}

update_sudoers() {
  sudoers_file="/etc/sudoers"
  sudoers_backup="${sudoers_file}.$(date +%Y%m%d%H%M%S).bak"

  if ! grep -qxF "${sudoers_string}" "${sudoers_file}"; then
    /bin/cp -p "${sudoers_file}" "${sudoers_backup}"
    echo "Backup of sudoers created at ${sudoers_backup}"
    echo "${sudoers_string}" | visudo -cf - && echo "${sudoers_string}" >> "${sudoers_file}"

    if [ $? -eq 0 ]; then
      echo "Sudoers file updated successfully."
    else
      echo "Failed to update sudoers file. Restoring backup..."
      /bin/cp -p "${sudoers_backup}" "${sudoers_file}"
      exit 1
    fi
  else
    echo "Sudoers string already present. No changes made."
  fi
}

update_authorized_keys() {
  touch "${user_home}/.ssh/authorized_keys"
  if ! grep -qxF "${ssh_public_key}" "${user_home}/.ssh/authorized_keys"; then
    echo "${ssh_public_key}" >> "${user_home}/.ssh/authorized_keys"
    chown -R "${user_name}:${user_group}" "${user_home}/.ssh"
    chmod 600 "${user_home}/.ssh/authorized_keys"
  fi
}

update_sshd_config() {
  /bin/cp -f ${sshd_config} ${sshd_config}.$(date +%Y%m%d%H%M%S).bak
  awk -v allow_groups="${allow_groups}" '
  BEGIN { allowGroupsFound = 0 }
  /^AllowGroups/ {
      allowGroupsFound = 1
      if ($0 !~ allow_groups) {
          $0 = $0 " " allow_groups
      }
  }
  { print }
  END {
      if (!allowGroupsFound) {
          print "AllowGroups " allow_groups
      }
  }' "${sshd_config}" > /tmp/${sshd_config_file}.new

  if [ -s /tmp/${sshd_config_file}.new ]; then
      /bin/mv -f /tmp/${sshd_config_file}.new "${sshd_config}"
      /bin/chmod 600 "${sshd_config}"
      /bin/chown root:root "${sshd_config}"
      systemctl restart sshd
  fi 
}


# ----------------------------------------------------------------------------
# RUNTIME
# \(^_^)/                                      __|__
#                                     __|__ *---o0o---*
#                            __|__ *---o0o---*
#                         *---o0o---*
# ----------------------------------------------------------------------------
configure
create_user
create_home
update_sudoers
update_authorized_keys
update_sshd_config
