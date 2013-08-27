//
//  ofxImagePlayer.cpp
//  remoteUI_Sketch
//
//  Created by Oriol Ferrer Mesià on 21/08/13.
//
//

#include "ofxImagePlayer.h"
#include <Cocoa/Cocoa.h>

ofxImagePlayer::ofxImagePlayer(){
	loaded = false;
	playing = false;
	loop = false;
	tex = NULL;
	usedMemory = 0;
}

bool ofxImagePlayer::setup(string folder, bool preloaded){

	folderPath = folder;
	preload = preloaded;
    ofDirectory dir;
    int nFiles = dir.listDir(folder);
    dir.sort();
    if(nFiles) {
        for(int i=0; i<dir.numFiles(); i++) {
            filenames.push_back(  dir.getPath(i) );
        }
    } else ofLog(OF_LOG_ERROR, "Could not find folder " + folder);

    loaded = true;
	playIndex = 0;

	if (preloaded){
		for(int i = 0; i < filenames.size(); i++){
			ofTexture *t = loadImg(filenames[i], USE_NSIMAGE);
			textures.push_back(t);
			usedMemory += (((t->getTextureData().glTypeInternal == GL_RGBA ) ? 4 : 3) * t->getWidth() * t->getHeight()) / (1024.0f * 1024.0);

		}
	}else{
		tex = loadImg(filenames[playIndex], USE_NSIMAGE);
		usedMemory = (((tex->getTextureData().glTypeInternal == GL_RGBA ) ? 4 : 3) * tex->getWidth() * tex->getHeight()) / (1024.0f * 1024.0);
	}
}

ofTexture* ofxImagePlayer::loadImg(string file, bool useNSImage){

	ofTexture *t = new ofTexture();
	if(useNSImage){
		NSAutoreleasePool * p = [[NSAutoreleasePool alloc] init];
		NSString * path = [NSString stringWithFormat:@"%s", ofToDataPath(file, true).c_str()];
		NSImage * img = [[NSImage alloc] initWithContentsOfFile:path];

		NSBitmapImageRep * rep = [[img representations] objectAtIndex:0];
		int comps = [rep numberOfPlanes];
		int glFormat = GL_RGB;
		if ([rep hasAlpha]) glFormat = GL_RGBA;

		t->loadData([rep bitmapData], [rep pixelsWide], [rep pixelsHigh], glFormat);
		[img release];
		[p release];
	}else{
		ofImage img;
		img.setUseTexture(false);
		img.loadImage(file);
		t->loadData(img.getPixelsRef());
		img.clear();
	}

	cout << "ofxImagePlayer loading: " << file << endl;
	return t;
}

void ofxImagePlayer::setLoops(bool l){
	loop = l;
}

void ofxImagePlayer::setFrameRate(float frameRate){
	frameTime = 1.0f / frameRate;
}

void ofxImagePlayer::start(){
	playing = true;
}

void ofxImagePlayer::stop(){
	playing = false;
}

void ofxImagePlayer::setFrame(int f){
	playIndex = f % (filenames.size());
}

void ofxImagePlayer::update(float dt){

	if(playing){
		time += dt;

		if (time >= frameTime){
			time -= frameTime;
			playIndex ++;
			if( playIndex >= filenames.size() ){
				if (loop){
					playIndex = 0;
				}else{
					stop();
				}
			}
			if(playing && !preload){
				if (tex) delete tex; //erase previous tex
				tex = loadImg(filenames[playIndex], USE_NSIMAGE);
			}
		}
	}
}


void ofxImagePlayer::draw(float x, float y, float w, float h){

	if(preload){
		textures[playIndex]->draw(x,y);
	}else{
		tex->draw(x, y);
	}
}

void ofxImagePlayer::drawInfo(float x, float y){
	char aux[128];
	sprintf(aux, "%s: %d/%d (%0.1f Mb used)", folderPath.c_str(), playIndex, (int)filenames.size(), usedMemory );
	ofDrawBitmapStringHighlight(aux, x, y);
}
