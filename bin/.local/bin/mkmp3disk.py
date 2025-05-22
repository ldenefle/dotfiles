import os
import tqdm
import itertools
import subprocess
from typing import List
from pathlib import Path
from mutagen.flac import FLAC
from mutagen.id3 import ID3, TIT2, TPE1, TALB, TRCK
from mutagen.mp3 import EasyMP3 as MP3

# Set your directories
MUSIC_DIR=Path("/media/backup/media/files/")
PLAYLIST_DIR=Path("/media/backup/media/playlists")
MP3_DIR=Path("/home/lucas/Documents/mp3")

def sanitize_filename(name):
    return "".join(c if c not in '/\\:*?"<>|' else "_" for c in name)

def read_file_paths(m3u_file: Path) -> List[Path]:
    res = []
    with m3u_file.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if not line.startswith(str(MUSIC_DIR)):
                continue


            res.append(Path(line))
    return res

def process_playlist_file(flac_path: Path):
    # Read metadata from FLAC
    audio = FLAC(flac_path)
    title = audio.get("title", ["Unknown Title"])[0]
    artist = audio.get("artist", ["Unknown Artist"])[0]
    album = audio.get("album", ["Unknown Album"])[0]
    track = audio.get("tracknumber", [""])[0]

    # Construct MP3 path
    safe_filename = f"{sanitize_filename(artist)} - {sanitize_filename(title)}.mp3"
    mp3_path = MP3_DIR / safe_filename

    if flac_path.is_file() and flac_path.suffix.lower() == ".flac" and not mp3_path.exists():
        try:
            subprocess.run([
                "ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", str(flac_path), "-q:a", "2", str(mp3_path)
            ], check=True)

            # Tag MP3
            mp3 = MP3(mp3_path)
            mp3["title"] = title
            mp3["artist"] = artist
            mp3["album"] = album
            mp3["tracknumber"] = track
            mp3.save()

            print(f"Converted: {flac_path} → {mp3_path}")

        except subprocess.CalledProcessError as e:
            print(f"Weird error {e}")
def main():
    files = list(itertools.chain.from_iterable([read_file_paths(m3u_file) for m3u_file in PLAYLIST_DIR.rglob("*.m3u")]))

    for f in tqdm.tqdm(files):
        if f.suffix == ".flac":
            process_playlist_file(f)

if __name__ == "__main__":
    main()

