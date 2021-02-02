
libgphoto2 supported cameras  
<http://gphoto.org/proj/libgphoto2/support.php>

```shell
sudo modprobe v4l2loopback exclusive_caps=1
gphoto2 --stdout --capture-movie \
        | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
```

v4l2loopback - a kernel module to create V4L2 loopback devices  
<https://github.com/umlaeute/v4l2loopback>
