#ofxImagePlayer

Image sequence player, give it a folder and it will playback an image sequence. Can work by preloading all images at start, or by loading on the fly while playing back. 

Has an option to use NSImage based image loading too, which speeds up the loading. (see USE_NSIMAGE)

Very rough for now.

The long term idea is to offer an ofxThreadedImage "configurable length" buffer to load/unload upcoming/past images at a reasonable framerate on the fly without hicups (that is, for reasonably sized images). But we'll see if it happens...