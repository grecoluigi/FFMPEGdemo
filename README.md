#  FFMPEGdemo

![Screenshot 2](https://i.postimg.cc/DwgBgq8D/ffmpeg-screen1.jpg)
![Screenshot 2](https://i.postimg.cc/DwFxLCyL/ffmpeg-screen2.jpg)


FFMPEGdemo is a simple demo app that:
- Embeds an ffmpeg binary into the app
- Runs ffmpeg with provided arguments
- Has a bookmarking feature to save frequently used arguments. Bookmarks are saved in UserDefaults
- ffmpeg output is piped in the Xcode console when debugging
- Input file is processed upon file opening and the output is opened in a new finder window

Some of the code based on [this article by Jung Donghyun](https://crowjdh.blogspot.com/2017/05/use-ffmpeg-in-xcodefor-macos.html
)  

Build instructions:
- Dowload the latest ffmpeg binary for Mac at [this address](https://evermeet.cx/ffmpeg/) and place it the root directory. Your direcotry should look like this
_____
 |_ffmpeg  
 |_FFMPEGdemo (folder)  
 |_FFMPEGdemo.xcodeproj  
 |_README.md   
_____

- Open FFMPEGdemo.xcodeproj and change the build identifier and Team for signing

- Run the project