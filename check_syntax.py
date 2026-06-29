import sys

with open('js/schedule.js', 'rb') as f:
    data = f.read()

print(f"File size: {len(data)} bytes")
print(f"First 3 bytes (BOM check): {data[:3].hex()}")

# Check for null bytes or other weird characters
for i, b in enumerate(data):
    if b == 0:
        print(f"Null byte at position {i}")
        break

# Try to find the syntax error by checking each line
lines = data.decode('utf-8').split('\n')
print(f"Total lines: {len(lines)}")

# Check for template literal issues (backtick count)
backtick_count = 0
for i, line in enumerate(lines, 1):
    backtick_count += line.count('`')
    
if backtick_count % 2 != 0:
    print(f"WARNING: Odd number of backticks ({backtick_count})")
else:
    print(f"Backtick count: {backtick_count} (even - OK)")
