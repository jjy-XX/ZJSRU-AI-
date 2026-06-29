import urllib.request
import urllib.parse
import os
import time
from PIL import Image

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

images = [
    {
        'filename': 'tour-gate.jpg',
        'prompt': 'school'
    },
    {
        'filename': 'tour-library.jpg',
        'prompt': 'university library interior'
    },
    {
        'filename': 'tour-classroom.jpg',
        'prompt': 'campus'
    },
    {
        'filename': 'tour-dormitory.jpg',
        'prompt': 'university dormitory building'
    },
    {
        'filename': 'tour-canteen.jpg',
        'prompt': 'university cafeteria'
    },
    {
        'filename': 'tour-playground.jpg',
        'prompt': 'basketball'
    },
    {
        'filename': 'booking-shuttle.jpg',
        'prompt': 'campus'
    },
    {
        'filename': 'booking-library.jpg',
        'prompt': 'university library interior'
    },
    {
        'filename': 'booking-gym.jpg',
        'prompt': 'basketball'
    },
    {
        'filename': 'booking-meeting.jpg',
        'prompt': 'meeting room'
    },
]

print('下载所有图片...')
for img in images:
    filepath = os.path.join(images_dir, img['filename'])
    url = 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=' + urllib.parse.quote(img['prompt']) + '&image_size=landscape_16_9'
    try:
        print(f'下载: {img["filename"]} ({img["prompt"]})...')
        urllib.request.urlretrieve(url, filepath)
        with Image.open(filepath) as im:
            w, h = im.size
        size = os.path.getsize(filepath)
        print(f'  完成: {w}x{h}, {size} bytes')
        time.sleep(1)
    except Exception as e:
        print(f'  失败: {e}')

print('\n所有图片下载完成!')
