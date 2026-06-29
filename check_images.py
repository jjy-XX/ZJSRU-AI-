import os

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

print('检查图片文件有效性...')
for filename in os.listdir(images_dir):
    filepath = os.path.join(images_dir, filename)
    with open(filepath, 'rb') as f:
        header = f.read(4)
    
    is_jpeg = header[:3] == b'\xff\xd8\xff'
    is_png = header[:4] == b'\x89PNG'
    
    size = os.path.getsize(filepath)
    
    status = 'OK' if (is_jpeg or is_png) else 'INVALID'
    fmt = 'JPEG' if is_jpeg else ('PNG' if is_png else 'UNKNOWN')
    
    print(f'{filename:30s}  {status:8s}  {fmt:6s}  {size:>8d} bytes')

print('\n检查完成!')
