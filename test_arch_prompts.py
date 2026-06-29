import urllib.request
import urllib.parse
import os
import time
from PIL import Image

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

test_prompts = [
    'college building',
    'university architecture',
    'building facade',
    'campus building',
    'academic building',
    'education building',
    'school campus',
    'university college',
    'campus landscape',
    'university grounds',
]

print('测试建筑相关提示词...')
results = []
for i, prompt in enumerate(test_prompts):
    url = 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=' + urllib.parse.quote(prompt) + '&image_size=landscape_16_9'
    filepath = os.path.join(images_dir, f'test_arch_{i}.jpg')
    try:
        urllib.request.urlretrieve(url, filepath)
        with Image.open(filepath) as im:
            w, h = im.size
        is_square = w == h
        status = '占位图' if is_square else '成功'
        size = os.path.getsize(filepath)
        print(f'[{i:2d}] {prompt:25s} {status:6s} {w}x{h} ({size} bytes)')
        results.append({'prompt': prompt, 'ok': not is_square, 'width': w, 'height': h})
        os.remove(filepath)
        time.sleep(1)
    except Exception as e:
        print(f'[{i:2d}] {prompt:25s} 失败: {e}')
        results.append({'prompt': prompt, 'ok': False})

print('\n成功的提示词:')
for r in results:
    if r['ok']:
        print(f'  - {r["prompt"]} ({r["width"]}x{r["height"]})')
