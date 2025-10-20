#!/usr/bin/env python3

"""
MPV Stream Launcher (FINAL, ROBUST VERSION)
FIXED: Reverts script to a stable, working state for YouTube/Xvideos by removing
the complex, failing authentication logic.
"""

import os
import shutil
import sys

# Note: shlex is no longer needed but kept in imports list for simplicity.
# import shlex

# --- Configuration ---
MPV_PATH = shutil.which("mpv") or "mpv"
COOKIES_FILE = "/tmp/qute_cookies.txt"  # Path created by export_cookies.py

# Define the required video format string.
YTDL_FORMAT = "bestvideo[ext=mp4][vcodec^=avc1]/bestvideo[vcodec^=vp9]/bestvideo[vcodec^=av1]+bestaudio/best"

# User-Agent string.
USER_AGENT_STRING = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"


def qute_command(command: str):
    """Writes a command to qutebrowser's FIFO pipe for message passing."""
    try:
        fifo_path = os.environ.get("QUTE_FIFO")
        if fifo_path:
            with open(fifo_path, "w") as fifo:
                fifo.write(command + "\n")
        else:
            print(f"[FIFO] {command}", file=sys.stderr)
        return
    except Exception as e:
        print(f"Error writing to FIFO: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    if not shutil.which(MPV_PATH):
        qute_command(f'message-error "MPV not found in PATH: {MPV_PATH}"')
        return

    current_url = os.environ.get("QUTE_URL")
    if not current_url:
        qute_command('message-error "QUTE_URL not set."')
        return

    # NOTE: Cookie check is now OPTIONAL since we are not using cookies.
    # We remove the check to ensure the script doesn't fail on simple sites.

    # --- COMMAND CONSTRUCTION: RELIABLE YOUTUBE/XVIDEOS STREAMING ---

    # This minimal command avoids all complex quoting issues and relies only
    # on passing the URL, referrer, and ytdl-format (which are all standard strings).
    mpv_cmd = (
        f"spawn {MPV_PATH} "
        f'--referrer="{current_url}" '
        f'--ytdl-format="{YTDL_FORMAT}" '
        f'"{current_url}"'
    )

    qute_command('message-info "Launching MPV with standard streaming settings..."')
    qute_command(mpv_cmd)


if __name__ == "__main__":
    main()
