with open('js/schedule.js', 'rb') as f:
    data = f.read()

# Check for unusual characters
unusual = []
for i, b in enumerate(data):
    # Check for control characters (except common whitespace)
    if b < 32 and b not in (9, 10, 13):
        unusual.append((i, b, hex(b)))
        
if unusual:
    print(f"Found {len(unusual)} unusual bytes:")
    for pos, byte, hx in unusual[:10]:
        print(f"  Position {pos}: byte={byte} ({hx})")
else:
    print("No unusual control characters found")

# Check line endings
text = data.decode('utf-8')
lines = text.split('\n')
print(f"\nTotal lines: {len(lines)}")

# Check the first few and last few lines
print("\nFirst 5 lines:")
for i, line in enumerate(lines[:5]):
    print(f"  {i+1}: {repr(line[:80])}")

print("\nLast 5 lines:")
for i, line in enumerate(lines[-5:]):
    print(f"  {len(lines)-4+i}: {repr(line[:80])}")
