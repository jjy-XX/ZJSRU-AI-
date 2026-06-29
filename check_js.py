import re

with open('js/schedule.js', 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")

# Check for odd number of single quotes per line (simple check)
for i, line in enumerate(lines, 1):
    # Remove escaped quotes
    clean_line = line.replace("\\'", "")
    # Count single quotes
    count = clean_line.count("'")
    if count % 2 != 0:
        print(f"Line {i}: odd single quotes ({count}): {line.rstrip()[:120]}")

print("\nDone checking single quotes.")
