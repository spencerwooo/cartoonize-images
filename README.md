<div align="center">

![](https://i.loli.net/2019/02/02/5c54a32e7c922.png)

</div>

# Cartoonize Images

Cartoonize image with MATLAB.

## Structure

```bash
.
├── 1.jpg
├── 2.jpg
├── LICENSE
├── README.md
├── main.m
└── saturateImage.m

0 directories, 6 files
```

## Dependencies

- Computer Vision System Toolbox：计算机视觉核心库
- MATLAB Support Package for IP Cameras：IP 摄像头支持库

## Usage

1. Open `main.m` in MATLAB
2. Configure settings in line 4-5, with your own local image, or your IP camera's video stream url

```matlab
% % % % % % % % % % % % % % % % % % % % % % % % %
% Change below according to your configurations %
% % % % % % % % % % % % % % % % % % % % % % % % %
imgPath = '1.jpg';
url = 'http://192.168.1.7:8080/video';
```

3. Run the program

## Expected Result

![](https://i.loli.net/2019/02/02/5c54a5e5556da.jpg)

---

📸 Cartoonize Images ©Spencer Woo. Released under the MIT License.

Authored and maintained by Spencer Woo.

[@Blog](https://spencerwoo.com/) · [ⒿJike](https://web.okjike.com/user/4DDA0425-FB41-4188-89E4-952CA15E3C5E/post) · [@GitHub](https://github.com/spencerwooo)
