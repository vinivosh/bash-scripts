"""
Clean up a TXT file for TTS-friendly input (e.g. Chatterbox speech synthesis).

Usage:
    python process_text_for_tts.py path/to/file.txt

Writes path/to/file_processed.txt (overwriting it if it already exists).
"""

import argparse
import os
import re
import unicodedata

# Punctuation/space chars kept as-is, in addition to ASCII letters and digits.
ALLOWED_EXTRA_CHARS = " -,.!?;()':"


def strip_accents(text: str) -> str:
    """Normalize accented characters to their closest non-accented
    equivalent."""
    normalized = unicodedata.normalize("NFKD", text)
    return "".join(ch for ch in normalized if not unicodedata.combining(ch))


def convert_dashes(text: str) -> str:
    """
    Convert en-dashes (-) and em-dashes (--) into simple hyphens (-).

    Em-dashes additionally get a space inserted before/after them if one isn't already present, before being
    collapsed to a hyphen.
    """
    text = re.sub(r"(?<!\s)—", " —", text)  # add missing space before em-dash
    text = re.sub(r"—(?!\s)", "— ", text)  # add missing space after em-dash

    text = text.replace("—", "-")
    text = text.replace("–", "-")  # en-dash: direct swap, no spacing rule
    return text


def remove_disallowed_chars(text: str) -> str:
    """Keep only ASCII alphanumerics, the allowed punctuation, and newlines."""
    allowed = set(ALLOWED_EXTRA_CHARS)
    allowed.add("\n")
    return "".join(
        ch for ch in text if ch.isascii() and (ch.isalnum() or ch in allowed)
    )


def collapse_spaces(text: str) -> str:
    """Collapse runs of two-or-more spaces into a single space."""
    return re.sub(r" {2,}", " ", text)


def collapse_blank_lines(text: str) -> str:
    """Collapse runs of two-or-more blank lines into a single blank line."""
    lines = text.split("\n")
    result = []
    prev_blank = False
    for line in lines:
        is_blank = line.strip() == ""
        if is_blank:
            if not prev_blank:
                result.append("")
            prev_blank = True
        else:
            result.append(line)
            prev_blank = False
    return "\n".join(result)


def process_text(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    text = strip_accents(text)
    text = convert_dashes(text)
    text = remove_disallowed_chars(text)
    text = collapse_spaces(text)
    text = collapse_blank_lines(text)
    return text


def build_output_path(input_path: str) -> str:
    root, ext = os.path.splitext(input_path)
    return f"{root}_processed{ext}"


def main():
    parser = argparse.ArgumentParser(
        description="Clean up a TXT file for TTS-friendly speech synthesis input."
    )
    parser.add_argument("input_file", help="Path to the input .txt file")
    args = parser.parse_args()

    with open(args.input_file, "r", encoding="utf-8") as f:
        text = f.read()

    processed = process_text(text)

    output_path = build_output_path(args.input_file)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(processed)

    print(f"Processed file written to: {output_path}")


if __name__ == "__main__":
    main()
