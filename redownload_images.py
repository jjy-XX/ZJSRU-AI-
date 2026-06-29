import urllib.request
import urllib.parse
import os
import time

images_dir = r'c:\Users\86180\Desktop\智慧校园\images'

images = [
    {
        'filename': 'tour-gate.jpg',
        'prompt': 'grand university main entrance gate with stone pillars and school name sign, Zhejiang Shuren University, blue sky white clouds, green trees both sides, students walking through, wide angle shot, photorealistic, high quality, 8k'
    },
    {
        'filename': 'tour-library.jpg',
        'prompt': 'modern university library interior, tall bookshelves filled with books, large windows with natural light, wooden reading tables, students studying quietly, peaceful atmosphere, warm lighting, photorealistic, high detail'
    },
    {
        'filename': 'tour-classroom.jpg',
        'prompt': 'modern university classroom building exterior, red brick architecture, white window frames, green lawn in front, students carrying backpacks walking to class, sunny morning, campus life, photorealistic'
    },
    {
        'filename': 'tour-dormitory.jpg',
        'prompt': 'cozy university student dormitory building, warm yellow exterior walls, balconies with green plants, tree lined walkway, afternoon golden sunlight, students chatting outside, home-like atmosphere, photorealistic'
    },
    {
        'filename': 'tour-canteen.jpg',
        'prompt': 'bright modern university cafeteria food court, multiple food stalls with colorful signs, students holding trays choosing food, clean dining area with tables and chairs, warm inviting atmosphere, photorealistic'
    },
    {
        'filename': 'tour-playground.jpg',
        'prompt': 'university sports stadium with red running track and green soccer field, blue sky with white clouds, students jogging and exercising, bleachers on the side, vibrant energetic atmosphere, wide angle, photorealistic'
    },
    {
        'filename': 'booking-shuttle.jpg',
        'prompt': 'blue and white campus shuttle bus parked at bus stop, university students boarding the bus, modern vehicle design, campus buildings in background, sunny day, transportation theme, photorealistic'
    },
    {
        'filename': 'booking-library.jpg',
        'prompt': 'quiet university library study area with individual reading seats, table lamps, books stacked on desks, students focused on studying, large floor to ceiling windows, peaceful study environment, photorealistic'
    },
    {
        'filename': 'booking-gym.jpg',
        'prompt': 'modern indoor university gymnasium with basketball court, wooden floor, basketball hoop, bright overhead lighting, sports equipment around, athletic facility, clean and spacious, photorealistic'
    },
    {
        'filename': 'booking-meeting.jpg',
        'prompt': 'professional university conference room with long table and office chairs, projector screen on wall, large windows with campus view, modern meeting space, academic lecture hall style, clean and organized, photorealistic'
    }
]

print('开始重新下载图片...')
for img in images:
    filepath = os.path.join(images_dir, img['filename'])
    try:
        print(f'下载中: {img["filename"]}...')
        url = 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=' + urllib.parse.quote(img['prompt']) + '&image_size=landscape_16_9'
        urllib.request.urlretrieve(url, filepath)
        size = os.path.getsize(filepath)
        print(f'  完成! ({size} bytes)')
        time.sleep(1)
    except Exception as e:
        print(f'  失败: {e}')

print('\n下载完成!')
