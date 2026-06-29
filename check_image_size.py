import os
from PIL import Image

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

print('检查图片尺寸和内容...')
for filename in sorted(os.listdir(images_dir)):
    if not filename.endswith('.jpg'):
        continue
    filepath = os.path.join(images_dir, filename)
    try:
        with Image.open(filepath) as img:
            print(f'{filename:30s}  {img.size[0]}x{img.size[1]}  {img.mode}')
    except Exception as e:
        print(f'{filename:30s}  ERROR: {e}')

print('\n检查完成!')
