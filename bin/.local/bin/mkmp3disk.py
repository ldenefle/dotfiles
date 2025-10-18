import os
import shutil
import paramiko
import logging
import tqdm
import itertools
import subprocess
import tempfile
from typing import List
from pathlib import Path
from mutagen.flac import FLAC, error
from mutagen.id3 import ID3, TIT2, TPE1, TALB, TRCK
from mutagen.mp3 import EasyMP3 as MP3

# Set your directories
MUSIC_DIR=Path("/media/backup/media/files/")
PLAYLIST_DIR=Path("/media/backup/media/playlists")
MP3_DIR=Path("/home/lucas/Documents/dj/mp3")
CACHED_RAW_DIR=Path("/home/lucas/Documents/dj/raw")
REMOTE_BASEDIR=Path("/media/files")

logger = logging.getLogger()

def cache_file(ssh, playlist_name: str, server_path: Path):
    relative_path = server_path.relative_to(REMOTE_BASEDIR)

    destination_path = CACHED_RAW_DIR / playlist_name / relative_path

    destination_path.parent.mkdir(parents=True, exist_ok=True)
    return destination_path

def sanitize_filename(name):
    return "".join(c if c not in '/\\:*?"<>|\t' else "_" for c in name)

def process_playlist_file(src_path: Path):
    if not src_path.is_file():
        return

    suffix = src_path.suffix.lower()

    if suffix == ".mp3":
        dest_path = MP3_DIR / src_path.name
        if dest_path.exists():
            return
        logger.debug(f"copying mp3 {src_path} {dest_path}")
        shutil.copyfile(src_path, dest_path)
    elif suffix == ".flac":
        try:
            # Read metadata from FLAC
            audio = FLAC(src_path)
            title = audio.get("title", ["Unknown Title"])[0]
            artist = audio.get("artist", ["Unknown Artist"])[0]
            album = audio.get("album", ["Unknown Album"])[0]
            track = audio.get("tracknumber", [""])[0]

            # Construct MP3 path
            safe_filename = f"{sanitize_filename(artist)} - {sanitize_filename(title)}.mp3"

            mp3_path = MP3_DIR / safe_filename

            # Don't perform conversion if file already present to save some time
            if mp3_path.exists():
                return

            subprocess.run([
                "ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", str(src_path), "-q:a", "2", str(mp3_path)
            ], check=True)

            # Tag MP3
            mp3 = MP3(mp3_path)
            mp3["title"] = title
            mp3["artist"] = artist
            mp3["album"] = album
            mp3["tracknumber"] = track
            mp3.save()

            print(f"converted: {src_path} → {mp3_path}")
        except error as e:
            logger.error(f"Weird flac error on {src_path}")
            logger.exception(e)
        except subprocess.CalledProcessError as e:
            logger.error(f"ffmpeg error on {src_path}")
            logger.exception(e)

def fetch_playlist_filenames(ssh, ip, username, playlist_name, key_filename=None, password=None):
    """
    Connects to a server over SSH, runs the navidrome playlist command,
    and extracts file paths from the M3U output.

    Args:
        ip (str): The IP address of the server.
        username (str): SSH username.
        playlist_name (str): Playlist name to fetch.
        key_filename (str, optional): Path to private SSH key.
        password (str, optional): Password for SSH or sudo (if not using a key).

    Returns:
        list[str]: List of file paths relative to /media/files/.
    """

    command = (
        f"sudo -su navidrome /opt/navidrome "
        f"--configfile /var/lib/navidrome/navidrome.toml "
        f"pls -p '{playlist_name}'"
    )

    # Execute command
    _, _, stderr = ssh.exec_command(command)
    output = stderr.read().decode('utf-8')
    logger.debug(f"paramiko output {command} {output}")

    # Extract file paths that start with /media/files/
    for line in output.splitlines():
        if line.startswith("/media/files/"):
            yield (playlist_name, Path(line))

def main():
    playlists = [ "lisa", "Grimey-Garagey"]
    ip = "100.93.225.35"
    # Setup SSH client
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    # Connect
    ssh.connect(ip, username="lucas")

    files = list(itertools.chain(*[fetch_playlist_filenames(ssh, "100.93.225.35", "lucas", p) for p in playlists]))
    ssh.close()

    logger.info(f"Files {files}")

    # Create a temporary include file
    with tempfile.NamedTemporaryFile("w", delete=False) as include_file:
        for (_, rel) in files:
            include_file.write(str(rel) + "\n")
        include_file_path = include_file.name

    # Construct rsync command
    rsync_cmd = [
        "rsync",
        "-avz",                          # archive, verbose, compress
        "--files-from", include_file_path,
        f"lucas@{ip}:/",  # remote root
        str(CACHED_RAW_DIR)                   # local root
    ]

    print("Running:", " ".join(rsync_cmd))
    subprocess.run(rsync_cmd, check=True)

    # Read all the files from the cached directory
    files = list(CACHED_RAW_DIR.rglob("*.flac")) + list(CACHED_RAW_DIR.rglob("*.mp3"))

    # Create mp3 directory
    MP3_DIR.mkdir(parents=True, exist_ok=True)

    for f in files:
        process_playlist_file(f)

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    main()

