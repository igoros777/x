# RPi5 LibreELEC Configuration Notes

## FTPS Data Source Issue with Kodi
When using FTPS as the data source, the current **stable version of Kodi (as of 2024-12-28)** contains a cURL bug. This bug allows FTPS connections but prevents the system from retrieving file listings.

### Workarounds:
1. **Upgrade to the unstable nightly build.**
2. **Downgrade to Kodi 19.**

## Steps for Upgrading LibreELEC to the Latest Nightly Build

1. **Disable Automatic Updates:**
   - Turn off automatic updates, update notifications, and performance data sharing.

2. **Enable SSH:**
   - Enable the SSH daemon and set a new password for secure access.

3. **SSH into the System:**
   - Use a terminal to connect via SSH:
     ```bash
     ssh root@<IP_ADDRESS>
     ```

4. **Download the Latest Nightly Build:**
   - Navigate to the update directory:
     ```bash
     cd /storage/.update
     ```
   - Download the latest nightly build:
     ```bash
     wget https://test.libreelec.tv/${major_release}/RPi/RPi5/LibreELEC-RPi5.aarch64-${major_release}-nightly-${date}-${git_commit_hash}.img.gz
     ```

5. **Reboot to Install the Upgrade:**
   - Reboot the system, and LibreELEC will automatically install the update.

6. **Verify the Installed Version:**
   - SSH back into the system. The version information should display something like:
     ```
     LibreELEC (community): nightly-20241228-8d27a69 (RPi5.aarch64)
     ```

## Configuring FTPS Data Source

To configure FTPS, **manually enter the following strings** into the FTPS data source configuration. Do not use the "Browse" option or the FTPS dropdown selection:

- For movies:
  ```
  ftp://username:password@ftp.domain.com:21/movies/auth=TLS&verifypeer=false
  ```

- For TV shows:
  ```
  ftp://username:password@ftp.domain.com:21/tvshows/auth=TLS&verifypeer=false
  ```

Replace `username` and `password` with your actual credentials. The `auth=TLS&verifypeer=false` options force TLS and ensure compatibility.


