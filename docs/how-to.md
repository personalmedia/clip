# How-To

## Send directly from share menu on iOS
I created an iOS shortcut to send images, files, folder, URLs \
or text directly from the share-menu 
https://routinehub.co/shortcut/13990/

[//]: # (Todo: Add screenshots)

<br>

## Send directly from share menu on Android
The [Web Share Target API](https://developer.mozilla.org/en-US/docs/Web/Manifest/share_target) is implemented.

When the PWA is installed, it will register itself to the share-menu of the device automatically.

<br>

## Send directly via command-line interface
Send files or text with CLIP via command-line interface. \
This opens CLIP in the default browser where you can choose the receiver.

### Usage
```bash
clip -h
```
```
Send files or text with CLIP via command-line interface.
Current domain: https://clip-dev.onrender.com/

Usage:
Open CLIP:		clip
Send files:		clip file1/directory1 (file2/directory2 file3/directory3 ...)
Send text:		clip -t "text"
Specify domain:		clip -d "https://clip.pm/"
Show this help text:	clip (-h|--help)

This clip-cli version was released alongside v1.10.4
```

<br>

### Setup

#### Linux / Mac
1. Download the latest _clip-cli.zip_ from the [releases page](https://github.com/personalmedia/clip/releases)
   ```shell
   wget "https://github.com/personalmedia/clip/releases/download/v1.11.2/clip-cli.zip"
   ```
   or
   ```shell
   curl -LO "https://github.com/personalmedia/clip/releases/download/v1.11.2/clip-cli.zip"
   ```
2. Unzip the archive to a folder of your choice e.g. `/usr/share/clip-cli/`
   ```shell
   sudo unzip clip-cli.zip -d /usr/share/clip-cli/
   ```
3. Copy the file _.clip-cli-config.example_ to _.clip-cli-config_
   ```shell
   sudo cp /usr/share/clip-cli/.clip-cli-config.example /usr/share/clip-cli/.clip-cli-config
   ```
4. Make the bash file _clip_ executable
   ```shell
   sudo chmod +x /usr/share/clip-cli/clip
   ```
5. Add a symlink to /usr/local/bin/ to include _clip_ to _PATH_
   ```shell
   sudo ln -s /usr/share/clip-cli/clip /usr/local/bin/clip
   ```

<br>

#### Windows
1. Download the latest _clip-cli.zip_ from the [releases page](https://github.com/personalmedia/clip/releases)
2. Put file in a preferred folder e.g. `C:\Program Files\clip-cli`
3. Inside this folder, copy the file _.clip-cli-config.example_ to _.clip-cli-config_
4. Search for and open `Edit environment variables for your account`
5. Click `Environment Variables…`
6. Under _System Variables_ select `Path` and click _Edit..._
7. Click _New_, insert the preferred folder (`C:\Program Files\clip-cli`), click *OK* until all windows are closed
8. Reopen Command prompt window

**Requirements**

As Windows cannot execute bash scripts natively, you need to install [Git Bash](https://gitforwindows.org/).

Then, you can also use clip-cli from the default Windows Command Prompt 
by using the shell file instead of the bash file which then itself executes 
_clip-cli_ (the bash file) via the Git Bash.
```shell
clip.sh -h
```

<br>

## Send multiple files and directories directly from context menu on Windows

### Registering to open files with CLIP
It is possible to send multiple files with CLIP via the context menu by adding clip-cli to Windows `Send to` menu:
1. Download the latest _clip-cli.zip_ from the [releases page](https://github.com/personalmedia/clip/releases)
2. Unzip the archive to a folder of your choice e.g. `C:\Program Files\clip-cli\`
3. Inside this folder, copy the file _.clip-cli-config.example_ to _.clip-cli-config_
4. Copy the shortcut _send with CLIP.lnk_
5. Hit Windows Key+R, type: `shell:sendto` and hit Enter.
6. Paste the copied shortcut into the directory
7. Open the properties window of the shortcut and edit the link field to point to _send-with-clip.ps1_ located in the folder you used in step 2: \
   `"C:\Program Files\PowerShell\7\pwsh.exe" -File "C:\Program Files\clip-cli\send-with-clip.ps1"`
8. You are done! You can now send multiple files and directories directly via CLIP:

   _context menu_ > _Send to_ > _CLIP_

##### Requirements
As Windows cannot execute bash scripts natively, you need to install [Git Bash](https://gitforwindows.org/).

<br>

## Send multiple files and directories directly from context menu on Ubuntu using Nautilus

### Registering to open files with CLIP
It is possible to send multiple files with CLIP via the context menu by adding clip-cli to Nautilus `Scripts` menu:
1. Register _clip_ as executable via [guide above](#linux).
2. Copy the shell file _send-with-clip_ to `~/.local/share/nautilus/scripts/` to include it in the context menu
   ```shell
   cp /usr/share/clip-cli/send-with-clip ~/.local/share/nautilus/scripts/
   ```
3. Make the shell file _send-with-clip_ executable
   ```shell
   chmod +x ~/.local/share/nautilus/scripts/send-with-clip
   ```
4. You are done! You can now send multiple files and directories directly via CLIP:

   _context menu_ > _Scripts_ > _send-with-clip_

<br>

## File Handling API
The [File Handling API](https://learn.microsoft.com/en-us/microsoft-edge/progressive-web-apps-chromium/how-to/handle-files)
was implemented, but it was removed as default file associations were overwritten ([#17](https://github.com/personalmedia/clip/issues/17),
[#116](https://github.com/personalmedia/clip/issues/116) [#190](https://github.com/personalmedia/clip/issues/190))
and it only worked with explicitly specified file types and couldn't handle directories at all.

[< Back](/README.md)
