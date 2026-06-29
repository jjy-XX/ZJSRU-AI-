import os
from PIL import Image

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

print('检查图片详细信息...')
for filename in sorted(os.listdir(images_dir)):
    if not filename.endswith('.jpg'):
        continue
    filepath = os.path.join(images_dir, filename)
    size = os.path.getsize(filepath)
    try:
        with Image.open(filepath) as img:
            w, h = img.size
            ratio = f'{w/w:g}:{h/w:.2f}'
            is_square = w == h
            print(f'{filename:30s}  {w:>5d}x{h:<5d}  {size:>8d} bytes  {"正方形" if is_square else "横向"}')
    except Exception as e:
        print(f'{filename:30s}  ERROR: {e}')

print('\n检查完成!')
