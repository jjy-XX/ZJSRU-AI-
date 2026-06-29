import urllib.request
import urllib.parse
import os
import time

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

images = [
    {
        'filename': 'tour-gate.jpg',
        'prompt': 'university school gate entrance'
    },
    {
        'filename': 'tour-library.jpg',
        'prompt': 'university library building'
    },
    {
        'filename': 'tour-classroom.jpg',
        'prompt': 'university classroom building'
    },
    {
        'filename': 'tour-dormitory.jpg',
        'prompt': 'university student dormitory'
    },
    {
        'filename': 'tour-canteen.jpg',
        'prompt': 'university cafeteria dining hall'
    },
    {
        'filename': 'tour-playground.jpg',
        'prompt': 'university sports field stadium'
    },
    {
        'filename': 'booking-shuttle.jpg',
        'prompt': 'campus shuttle bus'
    },
    {
        'filename': 'booking-library.jpg',
        'prompt': 'library study room'
    },
    {
        'filename': 'booking-gym.jpg',
        'prompt': 'indoor gym basketball court'
    },
    {
        'filename': 'booking-meeting.jpg',
        'prompt': 'university conference room'
    }
]

print('下载图片（简单提示词）...')
for img in images:
    filepath = os.path.join(images_dir, img['filename'])
    url = 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=' + urllib.parse.quote(img['prompt']) + '&image_size=landscape_16_9'
    try:
        print(f'下载: {img["filename"]}...')
        urllib.request.urlretrieve(url, filepath)
        size = os.path.getsize(filepath)
        
        from PIL import Image
        with Image.open(filepath) as im:
            w, h = im.size
        
        print(f'  完成: {w}x{h}, {size} bytes')
        time.sleep(2)
    except Exception as e:
        print(f'  失败: {e}')

print('\n下载完成!')
